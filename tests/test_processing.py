"""Execute every production processing gate with native fault injection on Windows.

These fixtures do not prove Avidemux assembled every input. Production therefore
retains all intermediates even after a successful final remux.
"""
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

from test_final_remux import ROOT, TEXT


def stages():
    result = []
    lines = TEXT.splitlines()
    for index, line in enumerate(lines):
        if line.strip().startswith('docs\\programs\\') and ('processing.log' in line or 'avidemux_cli --load' in line):
            start = index
            while not lines[start].strip().startswith('set "stage_name='):
                start -= 1
            end = index + 1
            while not lines[end].strip().startswith('call :require_stage_output'):
                end += 1
            end += 2
            output = re.search(r'call :require_stage_output "([^"]+)"', lines[end - 2])[1]
            result.append(('\n'.join(lines[start:end]), line.strip(), output))
    return result


class ProcessingSource(unittest.TestCase):
    def test_assembly_manifests_match_actual_append_order(self):
        commands = [line for line in TEXT.splitlines() if 'avidemux_cli --load' in line]
        for mode, command in zip(('unmasked', 'masked'), commands):
            expected = re.findall(r'--(?:load|append) "([^"]+)"', command)
            self.assertEqual((ROOT / 'docs/scripts' / ('assembly-inputs-' + mode + '.txt')).read_text().splitlines(), expected)
            self.assertIn('call :validate_assembly "' + mode + '" "docs\\temp\\AsteroidCity_S.mkv"', TEXT)

    def test_every_stage_has_status_and_output_gate(self):
        self.assertEqual(len(stages()), 57)
        for block, command, output in stages():
            self.assertIn('if not errorlevel 0 goto stage_failed', block)
            self.assertIn('call :require_stage_output "' + output + '"', block)
            if '\\mkvmerge ' in command:
                self.assertIn('if errorlevel 2 goto stage_failed', block)
                self.assertIn('if errorlevel 1 goto stage_warning', block)
            else:
                self.assertIn('if errorlevel 1 goto stage_failed', block)
        self.assertNotRegex(TEXT, r'(?im)^\s*del "docs\\temp\\')


@unittest.skipUnless(os.name == 'nt', 'requires actual Windows cmd.exe')
class WindowsProcessing(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.build = tempfile.TemporaryDirectory(prefix='processing-stub-')
        cls.stub = Path(cls.build.name) / 'processing.exe'
        compiler = (Path(os.environ['WINDIR']) / 'Microsoft.NET' / 'Framework64'
                    / 'v4.0.30319' / 'csc.exe')
        subprocess.run([str(compiler), '/nologo', '/target:exe',
                        '/out:' + str(cls.stub), str(ROOT / 'tests' / 'ProcessingStub.cs')],
                       check=True, capture_output=True, text=True)

    @classmethod
    def tearDownClass(cls):
        cls.build.cleanup()

    def run_stage(self, root, item, code, kind, missing_tool=False, missing_input=False, assembly_question=False):
        block, command, output = item
        temp = root / 'docs' / 'temp'
        temp.mkdir(parents=True)
        source = root / 'source with spaces.mkv'
        source.write_bytes(b'original synthetic source')
        sentinel = temp / 'previous-success.mkv'
        sentinel.write_bytes(b'preserved previous result')
        inputs = set(re.findall(r'"(docs\\[^"\n]+\.mkv)"', command)) - {output}
        for name in inputs:
            path = root / Path(name)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b'preserved input')
        if missing_input:
            (root / Path(sorted(inputs)[0])).unlink()
        exe = root / Path(command.split(' ', 1)[0] + '.exe')
        exe.parent.mkdir(parents=True)
        if not missing_tool:
            shutil.copy2(self.stub, exe)
        helper = TEXT.split(':: Processing helpers:', 1)[1].split(':: Workspace helpers:', 1)[0]
        harness = root / 'stage.cmd'
        harness.write_text('@echo off\nsetlocal DisableDelayedExpansion\npushd "%~dp0"\nsetlocal EnableDelayedExpansion\n'
                           + '(\n' + block + '\n)\necho downstream> downstream.txt\npopd\nexit /b 0\n'
                           + helper.replace('PAUSE', 'rem PAUSE'), encoding='utf-8')
        env = os.environ.copy()
        env['RESTORER_VALIDATION_MODE'] = 'exhaustive'
        env['STAGE_QUESTION'] = 'yes' if assembly_question else ''
        env.update(file=str(source), STAGE_MARKER=str(root / 'called.txt'),
                   STAGE_EXIT=str(code), STAGE_OUTPUT=kind)
        result = subprocess.run(['cmd.exe', '/d', '/c', 'stage.cmd'], cwd=root,
                                env=env, capture_output=True, text=True, timeout=15,
                                input='y\n' if assembly_question else None)
        self.assertEqual(source.read_bytes(), b'original synthetic source')
        self.assertEqual(sentinel.read_bytes(), b'preserved previous result')
        for name in inputs:
            if not missing_input:
                self.assertEqual((root / Path(name)).read_bytes(), b'preserved input')
        return result

    def test_assembly_question_is_visible_and_requires_explicit_answer(self):
        item = next(item for item in stages() if 'avidemux_cli --load' in item[1])
        with tempfile.TemporaryDirectory() as td:
            result = self.run_stage(Path(td), item, 0, 'normal', assembly_question=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('SYNTHETIC CODEC QUESTION', result.stderr)
            self.assertIn('SYNTHETIC ANSWER: y', result.stdout)

    def test_every_processing_command_stops_before_downstream_work(self):
        for number, item in enumerate(stages()):
            for code, kind in [(0, 'normal'), (1, 'normal'), (2, 'normal'),
                               (-1073741819, 'normal'), (0, 'missing'),
                               (0, 'empty'), (0, 'directory')]:
                with self.subTest(stage=number, code=code, output=kind), tempfile.TemporaryDirectory() as td:
                    root = Path(td) / 'Program with spaces & !mark'
                    root.mkdir()
                    result = self.run_stage(root, item, code, kind)
                    expected = 0 if code == 0 and kind == 'normal' else (
                        1 if code == 1 and '\\mkvmerge ' in item[1] else 2)
                    self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
                    self.assertEqual((root / 'downstream.txt').exists(), expected == 0)
                    diagnostic = (result.stdout + result.stderr if 'avidemux_cli --load' in item[1]
                                  else (root / 'docs' / 'temp' / 'processing.log').read_text())
                    self.assertIn('synthetic processing diagnostic', diagnostic)

    def test_missing_tools_and_assembly_inputs_stop(self):
        commands = stages()
        for item in [commands[0], next(x for x in commands if '\\ffmpeg ' in x[1]),
                     next(x for x in commands if '\\HandBrakeCLI ' in x[1]),
                     next(x for x in commands if '\\avidemux_cli ' in x[1])]:
            with self.subTest(command=item[1]), tempfile.TemporaryDirectory() as td:
                root = Path(td)
                result = self.run_stage(root, item, 0, 'normal', missing_tool=True)
                self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
                self.assertFalse((root / 'downstream.txt').exists())
        for item in [x for x in commands if '\\avidemux_cli ' in x[1]]:
            with self.subTest(assembly=item[2]), tempfile.TemporaryDirectory() as td:
                root = Path(td)
                result = self.run_stage(root, item, 0, 'normal', missing_input=True)
                self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
                self.assertFalse((root / 'called.txt').exists())
                self.assertFalse((root / 'downstream.txt').exists())

    def test_full_mode_controlflow_retains_work_and_stops_cascades(self):
        pipeline = TEXT[TEXT.index('if %version%==1 ('):]
        pipeline = re.sub(r'(?im)^\s*PAUSE\s*$', 'rem noninteractive', pipeline)
        for mode in (1, 2):
            for dialog in ('y', 'n'):
                for fail_at, validator_code, missing_validator in ((0, 0, False), (2, 0, False), (0, 2, False), (0, -1, False), (0, 0, True)):
                    with self.subTest(mode=mode, dialog=dialog, fail_at=fail_at, validator_code=validator_code, missing_validator=missing_validator), tempfile.TemporaryDirectory(prefix='full processing ') as td:
                        root = Path(td)
                        (root / 'docs' / 'temp').mkdir(parents=True)
                        logo = root / 'docs' / 'logos' / 'AsteroidCity_Logo1.mkv'
                        logo.parent.mkdir()
                        logo.write_bytes(b'synthetic logo sentinel')
                        scripts = root / 'docs/scripts'
                        scripts.mkdir()
                        if not missing_validator:
                            (scripts / 'Validate-Assembly.ps1').write_text('exit ' + str(validator_code) + '\n')
                        for tool in ('mkvtoolnix/mkvmerge', 'ffmpeg/ffmpeg',
                                     'handbrake/HandBrakeCLI', 'avidemux/avidemux_cli'):
                            target = root / 'docs' / 'programs' / (tool + '.exe')
                            target.parent.mkdir(parents=True, exist_ok=True)
                            shutil.copyfile(self.stub, target)
                        source = root / 'synthetic source.mkv'
                        source.write_bytes(b'original synthetic source')
                        env = os.environ.copy()
                        env['RESTORER_VALIDATION_MODE'] = 'exhaustive'
                        env.update(version=str(mode), dialog=dialog, dialog2='y',
                                   file=str(source) if dialog == 'y' else '"' + str(source) + '"',
                                   folder=str(root), STAGE_MARKER=str(root / 'called.txt'),
                                   STAGE_FAIL_AT=str(fail_at), STAGE_EXIT='2', STAGE_OUTPUT='normal')
                        (root / 'full.cmd').write_text('@echo off\nsetlocal EnableDelayedExpansion\npushd "%~dp0"\n'
                                                       + pipeline, encoding='utf-8')
                        result = subprocess.run(['cmd.exe', '/d', '/c', 'full.cmd'], cwd=root,
                                                env=env, capture_output=True, text=True, timeout=30)
                        rejected = bool(fail_at or validator_code or missing_validator)
                        self.assertEqual(result.returncode, 2 if rejected else 1, result.stdout + result.stderr)
                        self.assertEqual(source.read_bytes(), b'original synthetic source')
                        self.assertEqual(logo.read_bytes(), b'synthetic logo sentinel')
                        self.assertTrue((root / 'docs' / 'temp' / 'AsteroidCity.mkv').exists())
                        self.assertTrue((root / 'docs' / 'temp' / 'processing.log').exists())
                        if fail_at:
                            self.assertEqual(len((root / 'called.txt').read_text().splitlines()), 2)
                            self.assertFalse((root / 'docs' / 'temp' / 'AsteroidCity_S.mkv').exists())
                        elif validator_code or missing_validator:
                            self.assertTrue((root / 'docs/temp/AsteroidCity_S.mkv').exists())
                            self.assertFalse((root / 'docs/temp/final-remux.log').exists())
                        else:
                            self.assertIn('PASS:', (root / 'docs/temp/assembly-check.txt').read_text())
                            self.assertTrue((root / 'docs' / 'temp' / 'AsteroidCity_S.mkv').exists())
                            self.assertTrue((root / 'docs' / 'temp' / 'final-remux.log').exists())
