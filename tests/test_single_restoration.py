"""v2 retires masked output without changing the retained film recipe."""
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

from test_final_remux import ROOT, TEXT

HELPER = ROOT / 'docs/scripts/Select-Restoration.ps1'


class SingleRestorationSource(unittest.TestCase):
    def test_only_unmasked_media_path_remains(self):
        self.assertNotIn('else if %version%==2', TEXT)
        self.assertNotIn('Restoration (masked).mkv', TEXT)
        self.assertNotIn('_Pillarboxed.mkv', TEXT)
        self.assertEqual(TEXT.count('avidemux_cli --load'), 1)
        self.assertEqual(sum(line.strip().startswith('docs\\programs\\handbrake\\HandBrakeCLI ')
                             for line in TEXT.splitlines()), 8)
        self.assertIn('Asteroid City Theatrical Scope Restoration (unmasked).mkv', TEXT)
        for line in TEXT.splitlines():
            if line.strip().startswith('docs\\programs\\ffmpeg\\ffmpeg '):
                self.assertEqual(line.count(' -nostdin'), 1, 'Retain protection from accidental keyboard commands')

    def test_runtime_banner_matches_release_version(self):
        version = (ROOT / 'VERSION.txt').read_text(encoding='utf-8').strip()
        self.assertEqual(version, '2.0.0')
        banners = re.findall(r"Show-Banner 'Asteroid City Theatrical Scope Restorer v([0-9.]+)'",
                             HELPER.read_text(encoding='utf-8'))
        self.assertEqual(banners, [version])


@unittest.skipUnless(os.name == 'nt', 'requires Windows PowerShell 5.1 and cmd.exe')
class SingleRestorationWindows(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='single restoration & (test) ')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.install = self.root / 'Program'
        self.scripts = self.install / 'docs/scripts'
        self.scripts.mkdir(parents=True)
        self.helper = self.scripts / HELPER.name
        shutil.copyfile(HELPER, self.helper)
        self.source = self.root / 'generated dummy.mkv'
        self.source.write_bytes(b'generated synthetic selection sentinel')
        self.destination = self.root / 'Output'
        self.destination.mkdir()

    def command(self, *args, answers=None, env=None):
        return subprocess.run(['powershell.exe', '-NoProfile', '-STA', '-ExecutionPolicy', 'Bypass',
                               '-File', str(self.helper), *args], input=answers, capture_output=True,
                              text=True, encoding='utf-8', timeout=15, env=env)

    def assert_untouched(self):
        self.assertEqual(self.source.read_bytes(), b'generated synthetic selection sentinel')
        self.assertEqual(list(self.destination.iterdir()), [])
        self.assertFalse((self.install / 'docs/temp').exists())

    def test_asteroid_setup_skips_mode_menu_and_reviews_fixed_restoration(self):
        result = self.command('-Film', 'Asteroid', '-Manual',
                              answers=f'{self.source}\n{self.destination}\nq\n')
        self.assertEqual(result.returncode, 3, result.stdout + result.stderr)
        self.assertIn('Asteroid City Theatrical Scope Restorer v2.0.0', result.stdout)
        self.assertIn('Scope Theatrical (constant-height; unmasked 16:9 container)', result.stdout)
        self.assertIn('Asteroid City Theatrical Scope Restoration (unmasked).mkv', result.stdout)
        self.assertNotIn('Choose 1 or 2', result.stdout)
        self.assertNotIn('[2]', result.stdout)
        self.assertNotIn('Step 3 of 3', result.stdout)
        self.assert_untouched()

    def test_retired_mode_rejected_in_direct_and_validation_entry_points(self):
        for args in (('-Film', 'Asteroid', '-Mode', '2'),
                     ('-Film', 'Asteroid', '-Mode', '2', '-ValidateOnly',
                      '-Source', str(self.source), '-Destination', str(self.destination))):
            with self.subTest(args=args):
                result = self.command(*args)
                self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
                self.assertIn('retired', result.stdout.lower())
                self.assertNotIn('Step 1', result.stdout)
                self.assert_untouched()

    def test_retired_environment_mode_stops_before_workspace_or_fingerprint(self):
        env = os.environ.copy()
        env.update(file=str(self.source), folder=str(self.destination), version='2',
                   dialog='y', dialog2='y', RESTORER_SELECTION_READY='1')
        result = self.command('-Film', 'Asteroid', '-ValidateEnvironment', env=env)
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn('retired', result.stdout.lower())
        # Exercise the real BAT's --selected entry too, with a sentinel helper
        # that would reveal an incorrectly reached workspace operation.
        marker = self.install / 'workspace-called.txt'
        (self.scripts / 'Manage-Workspace.ps1').write_text(
            "[IO.File]::WriteAllText((Join-Path $PSScriptRoot '../../workspace-called.txt'), 'called')\nexit 0\n",
            encoding='utf-8')
        launcher = self.install / 'Asteroid-City-Scope-Restorer.bat'
        launcher.write_bytes(re.sub(r'(?im)^\s*PAUSE\s*$', 'rem unattended fixture', TEXT).replace('\n', '\r\n').encode())
        child = subprocess.run(['cmd.exe', '/d', '/c', launcher.name, '--selected'],
                               cwd=self.install, env=env, capture_output=True, text=True, timeout=15)
        self.assertEqual(child.returncode, 2, child.stdout + child.stderr)
        self.assertFalse(marker.exists(), 'obsolete mode reached workspace handling')
        self.assert_untouched()

    def test_bvs_mode_validation_still_accepts_both_existing_modes(self):
        for mode in ('1', '2'):
            with self.subTest(mode=mode):
                result = self.command('-Film', 'BvS', '-ValidateOnly', '-Source', str(self.source),
                                      '-Destination', str(self.destination), '-Mode', mode)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assert_untouched()

    def test_bvs_manual_mode_choice_remains_available(self):
        result = self.command('-Film', 'BvS', '-Manual',
                              answers=f'{self.source}\n{self.destination}\n2\nq\n')
        self.assertEqual(result.returncode, 3, result.stdout + result.stderr)
        self.assertIn('[2] IMAX 1.43:1 (unmasked)', result.stdout)
        self.assertIn('STEP 3 OF 3 - RESTORATION', result.stdout)
        self.assertIn('IMAX 1.43:1 (constant-width; unmasked 16:9 container)', result.stdout)
        self.assert_untouched()
