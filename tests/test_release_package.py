"""Release-package safety and reproducibility checks use tiny generated ZIPs."""
import importlib.util
import io
from pathlib import Path
import stat
import tempfile
import unittest
from unittest.mock import patch
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('release_builder', ROOT / 'tools/build_candidate.py')
BUILDER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BUILDER)


def archive(entries):
    data = io.BytesIO()
    with zipfile.ZipFile(data, 'w') as package:
        for name, content, mode in entries:
            info = zipfile.ZipInfo(name)
            info.filename = name
            info.create_system = 3
            info.external_attr = mode << 16
            package.writestr(info, content)
    data.seek(0)
    return data


class ReleasePackageTests(unittest.TestCase):
    def test_unsafe_windows_paths_are_rejected_before_any_extraction(self):
        bad = ('../escape', '/absolute', 'C:/escape', 'root/wrong',
               BUILDER.BASELINE_ROOT + '/../../escape',
               BUILDER.BASELINE_ROOT + '/docs\\escape',
               BUILDER.BASELINE_ROOT + '/NUL.txt', BUILDER.BASELINE_ROOT + '/COM1',
               BUILDER.BASELINE_ROOT + '/LPT2.log', BUILDER.BASELINE_ROOT + '/trailing.',
               BUILDER.BASELINE_ROOT + '/trailing ', BUILDER.BASELINE_ROOT + '/stream:ads',
               BUILDER.BASELINE_ROOT + '/wild*card', BUILDER.BASELINE_ROOT + '/control\nname')
        for name in bad:
            with self.subTest(name=name), tempfile.TemporaryDirectory() as directory:
                with zipfile.ZipFile(archive([(BUILDER.BASELINE_ROOT + '/safe.txt', b'safe', 0o100644),
                                              (name, b'bad', 0o100644)])) as package:
                    with self.assertRaises(RuntimeError):
                        BUILDER.extract_verified(package, Path(directory))
                self.assertEqual(list(Path(directory).iterdir()), [])

    def test_duplicate_case_collisions_and_file_parent_conflicts_are_rejected(self):
        root = BUILDER.BASELINE_ROOT
        for names in ((root+'/a', root+'/a'), (root+'/A', root+'/a'),
                      (root+'/a', root+'/a/b'), (root+'/a/b', root+'/a')):
            with self.subTest(names=names), zipfile.ZipFile(archive([(n,b'x',0o100644) for n in names])) as package:
                with self.assertRaises(RuntimeError):
                    BUILDER.preflight_zip(package)

    def test_links_special_entries_and_metadata_type_conflicts_are_rejected(self):
        for mode in (stat.S_IFLNK | 0o777, stat.S_IFIFO | 0o600, stat.S_IFCHR | 0o600, stat.S_IFDIR | 0o755):
            with self.subTest(mode=mode), zipfile.ZipFile(archive([(BUILDER.BASELINE_ROOT+'/item',b'target',mode)])) as package:
                with self.assertRaises(RuntimeError):
                    BUILDER.preflight_zip(package)

    def test_safe_archive_extracts_exact_regular_bytes(self):
        with tempfile.TemporaryDirectory() as directory:
            with zipfile.ZipFile(archive([(BUILDER.BASELINE_ROOT+'/docs/file.txt',b'synthetic',0o100644)])) as package:
                root = BUILDER.extract_verified(package, Path(directory))
            self.assertEqual((root/'docs/file.txt').read_bytes(), b'synthetic')
            self.assertEqual(BUILDER.inventory(root)['docs/file.txt']['bytes'], 9)

    def test_runtime_logo_and_unexpected_payload_deltas_are_refused(self):
        original = {'sha256':'original','bytes':4}
        modified = {'sha256':'modified','bytes':4}
        for name in ('docs/programs/tool.exe','docs/logos/logo.mkv','unlisted.txt'):
            with self.subTest(name=name), patch.dict(BUILDER.OVERLAYS,{name:'source'}):
                if name == 'unlisted.txt':
                    continue
                with self.assertRaises(RuntimeError):
                    BUILDER.verify_delta({name:original},{name:modified})
        with self.assertRaises(RuntimeError):
            BUILDER.verify_delta({'unlisted.txt':original},{'unlisted.txt':modified})
        with self.assertRaises(RuntimeError):
            BUILDER.verify_delta({'README.md':original},{})

    def test_repeated_zip_bytes_match_and_archive_is_never_overwritten(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)/'payload';root.mkdir()
            (root/'VERSION.txt').write_bytes(b'2.0.0\n')
            (root/'README.md').write_bytes(b'generated package check\n')
            contents=BUILDER.inventory(root)
            first=Path(directory)/'one.zip';second=Path(directory)/'two.zip'
            BUILDER.write_zip(root,first,contents);BUILDER.write_zip(root,second,contents)
            self.assertEqual(first.read_bytes(),second.read_bytes())
            with zipfile.ZipFile(first) as package:
                self.assertIsNone(package.testzip())
                self.assertEqual(package.namelist(), [BUILDER.PACKAGE_ROOT+'/README.md', BUILDER.PACKAGE_ROOT+'/VERSION.txt'])
            with self.assertRaises(FileExistsError):
                BUILDER.write_zip(root,first,contents)

    def test_committed_overlay_version_and_source_bytes_are_checked(self):
        def fake_git(*args, **kwargs):
            return b'2.0.0\n' if args[-1].endswith(':VERSION.txt') else b'line\nnext\n'
        with patch.object(BUILDER,'git',side_effect=fake_git):
            overlays=BUILDER.overlay_bytes('selected')
        self.assertEqual(overlays['VERSION.txt'],b'2.0.0\n')
        self.assertEqual(overlays['Asteroid-City-Scope-Restorer.bat'],b'line\r\nnext\r\n')
        with patch.object(BUILDER,'git',return_value=b'wrong version'):
            with self.assertRaises(RuntimeError):
                BUILDER.overlay_bytes('selected')

    def test_build_refuses_existing_output_bad_baseline_and_dirty_source(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);baseline=root/'baseline.zip';baseline.write_bytes(b'generated invalid baseline')
            output=root/'occupied';output.mkdir();sentinel=output/'keep';sentinel.write_bytes(b'keep')
            with self.assertRaises(RuntimeError):BUILDER.build(baseline,output)
            self.assertEqual(sentinel.read_bytes(),b'keep')
            with self.assertRaises(RuntimeError):BUILDER.build(baseline,root/'bad-hash')
            with patch.object(BUILDER,'BASELINE_SHA256',BUILDER.sha(baseline)), patch.object(BUILDER,'git',return_value=b' M dirty'):
                with self.assertRaises(RuntimeError):BUILDER.build(baseline,root/'dirty')
            self.assertFalse((root/'dirty').exists())

    def test_full_generated_build_uses_exact_revision_and_zip_only_public_checksum(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);baseline=root/'baseline.zip'
            baseline.write_bytes(archive([(BUILDER.BASELINE_ROOT+'/README.md',b'old',0o100644),
                                          (BUILDER.BASELINE_ROOT+'/docs/programs/tool.exe',b'tool',0o100644),
                                          (BUILDER.BASELINE_ROOT+'/docs/logos/logo.mkv',b'logo',0o100644)]).read())
            def fake_git(*args,**kwargs):return 'a'*40+'\n' if args[0]=='rev-parse' else b''
            overlays={'README.md':b'new','VERSION.txt':b'2.0.0\n'}
            with patch.object(BUILDER,'BASELINE_SHA256',BUILDER.sha(baseline)), patch.object(BUILDER,'git',side_effect=fake_git), patch.object(BUILDER,'overlay_bytes',return_value=overlays):
                manifest=BUILDER.build(baseline,root/'build',expected_commit='a'*40)
                with self.assertRaises(RuntimeError):BUILDER.build(baseline,root/'mismatch',expected_commit='b'*40)
            self.assertEqual(manifest['source_commit'],'a'*40)
            self.assertTrue(manifest['retained_tool_support_and_logo_bytes_unchanged'])
            lines=(root/'build/SHA256SUMS.txt').read_text(encoding='ascii').splitlines()
            self.assertEqual(lines,[BUILDER.sha(root/'build'/BUILDER.ASSET_NAME)+'  '+BUILDER.ASSET_NAME])
            self.assertFalse((root/'mismatch').exists())
