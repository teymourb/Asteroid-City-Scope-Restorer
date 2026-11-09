"""Exercise the real output guard with regular, empty, missing and directory paths."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

from test_final_remux import TEXT


@unittest.skipUnless(os.name == 'nt', 'requires actual Windows cmd.exe')
class StageOutputGuard(unittest.TestCase):
    def check_guard(self, text):
        guard = text.split('\n:require_stage_output\n', 1)[1].split('\n:stage_warning\n', 1)[0]
        with tempfile.TemporaryDirectory(prefix='output guard & (test) ') as directory:
            root = Path(directory)
            script = root / 'guard.cmd'
            script.write_text('@echo off\nsetlocal DisableDelayedExpansion\n'
                              'call :require_stage_output "%GUARD_TEST_PATH%"\n'
                              'exit /b %errorlevel%\n:require_stage_output\n' + guard)
            for kind, expected in (('missing', 1), ('empty', 1), ('directory', 1), ('regular', 0)):
                with self.subTest(kind=kind):
                    target = root / (kind + ' & (output)!.mkv')
                    if kind == 'directory':
                        target.mkdir()
                    elif kind != 'missing':
                        target.write_bytes(b'nonempty synthetic output' if kind == 'regular' else b'')
                    env = os.environ.copy()
                    env['GUARD_TEST_PATH'] = str(target)
                    result = subprocess.run(['cmd.exe', '/d', '/v:off', '/c', script.name],
                                            cwd=root, env=env, capture_output=True, text=True, timeout=15)
                    self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
                    if kind == 'regular':
                        self.assertEqual(target.read_bytes(), b'nonempty synthetic output')
                    elif kind == 'directory':
                        self.assertTrue(target.is_dir())
                    elif kind == 'empty':
                        self.assertEqual(target.read_bytes(), b'')
                    else:
                        self.assertFalse(target.exists())

    def test_current_launcher_accepts_only_nonempty_regular_files(self):
        self.check_guard(TEXT)
