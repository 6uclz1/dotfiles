"""Run with python3 -m unittest discover -s tests -v. Uses only the standard library."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]

class SetupFixture(unittest.TestCase):
    def setUp(self):
        self.repo = REPO
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles test ')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.home = self.base / 'home'
        (self.home / 'Library').mkdir(parents=True)
        self.original = b'# personal settings\nexport KEEP_ME=yes\n'
        (self.home / '.zshrc').write_bytes(self.original)
        self.bin = self.base / 'bin'
        self.bin.mkdir()
        self.engine = self.bin / 'mock-command'
        self.engine.write_text('#!' + sys.executable + '\n' + (REPO / 'tests/mock_command.py').read_text())
        self.engine.chmod(0o755)
        for command in ('uname', 'id', 'sw_vers', 'xcode-select', 'xcrun', 'curl', 'brew', 'ghq', 'git', 'defaults', 'stat', 'chflags', 'sleep', 'fzf'):
            (self.bin / command).symlink_to(self.engine)
        self.state_file = self.base / 'state.json'
        self.initial_prefs = {'NSGlobalDomain/KeyRepeat': ['int', '6'], 'NSGlobalDomain/com.apple.trackpad.scaling': ['float', '2'], 'com.apple.finder/ShowPathbar': ['string', 'old-value']}
        self.state_file.write_text(json.dumps({'prefs': self.initial_prefs, 'hidden': True, 'packages': ['unrelated-tool']}))
        self.env = dict(os.environ, HOME=str(self.home), PATH=str(self.bin) + ':/usr/bin:/bin:/usr/sbin:/sbin', MOCK_STATE=str(self.state_file), MOCK_ENGINE=str(self.engine), MOCK_BIN=str(self.bin), MOCK_REPO=str(REPO))
        for var in ('ZDOTDIR', 'GHQ_ROOT', 'DOTFILES_BRANCH', 'BASH_ENV'):
            self.env.pop(var, None)

    def state(self):
        return json.loads(self.state_file.read_text())

    def run_setup(self, *args, ok=True, bootstrap=False):
        result = subprocess.run(['/bin/bash', str(self.repo / ('bootstrap.sh' if bootstrap else 'setup.sh')), *args], env=self.env, text=True, capture_output=True)
        if ok: self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else: self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def backups(self):
        root = self.home / 'Library/Application Support/6uclz1-dotfiles/backups'
        return sorted(root.iterdir()) if root.exists() else []

    def snapshot(self):
        return {str(p.relative_to(self.home)): p.read_bytes() for p in self.home.rglob('*') if p.is_file()}

class SetupTests(SetupFixture):
    def test_config_is_validated_as_data(self):
        self.repo = self.base / 'checkout'
        shutil.copytree(REPO, self.repo, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        settings = self.repo / 'config/macos.tsv'
        original = settings.read_text()
        for content in (original + original, original.replace('\tint\t2', '\tint\t0'), original.replace('\tint\t2', '\tint\t$(touch SHOULD_NOT_EXIST)')):
            settings.write_text(content)
            self.run_setup('--only', 'macos', ok=False)
            self.assertFalse(self.state().get('mutations'))

    def test_lock_blocks_concurrent_execution(self):
        lock = self.home / 'Library/Application Support/6uclz1-dotfiles/lock'
        lock.mkdir(parents=True)
        self.run_setup('--only', 'shell', ok=False)
        self.assertTrue(lock.exists())
        self.assertEqual((self.home / '.zshrc').read_bytes(), self.original)

    @unittest.skipUnless(shutil.which('zsh'), 'Requires zsh')
    def test_cghq_cancellation_preserves_working_directory(self):
        script = 'compdef() { :; }; source "$1" || exit $?; ghq() { print -r -- /some/repository; }; fzf() { return 130; }; cghq || exit $?; pwd'
        result = subprocess.run([shutil.which('zsh'), '-dfi', '-c', script, 'zsh', str(REPO / 'shell/interactive.zsh')], env=self.env, cwd=self.home, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(Path(result.stdout.strip()).resolve(), self.home.resolve())

    def test_dry_run_and_check_are_read_only(self):
        before = self.snapshot()
        self.run_setup('--dry-run')
        self.run_setup('--dry-run', bootstrap=True)
        self.run_setup('--check', ok=False)
        self.assertEqual(before, self.snapshot())
        self.assertFalse(self.state().get('mutations'))
        self.assertEqual(self.backups(), [])

    def test_apply_twice_and_restore_exact_original(self):
        self.run_setup()
        backups = self.backups()
        self.assertEqual(len(backups), 1)
        old_backup = {p.name: p.read_bytes() for p in backups[0].iterdir()}
        self.assertIn('ghq', self.state()['packages'])
        self.assertIn('unrelated-tool', self.state()['packages'])
        self.run_setup()
        self.assertEqual(self.backups(), backups)
        self.assertEqual({p.name: p.read_bytes() for p in backups[0].iterdir()}, old_backup)
        self.assertEqual((self.home / '.zshrc').read_text().count('# >>> 6uclz1/dotfiles macOS >>>'), 1)
        self.run_setup('--check')
        self.run_setup('--restore', backups[0].name)
        self.assertEqual((self.home / '.zshrc').read_bytes(), self.original)
        self.assertFalse((self.home / '.zprofile').exists())
        self.assertEqual(self.state()['prefs'], self.initial_prefs)
        self.assertTrue(self.state()['hidden'])
        self.assertIn('ghq', self.state()['packages'])
        self.run_setup('--restore', backups[0].name)

    def test_restore_refuses_later_shell_edits(self):
        self.run_setup('--only', 'shell')
        target = self.home / '.zshrc'
        target.write_text(target.read_text() + '# subsequent user edit\n')
        expected = target.read_bytes()
        self.run_setup('--restore', self.backups()[0].name, ok=False)
        self.assertEqual(target.read_bytes(), expected)

    def test_partial_defaults_failure_is_recoverable(self):
        self.env['MOCK_WRITE_FAILURE'] = 'InitialKeyRepeat'
        self.run_setup('--only', 'macos', ok=False)
        self.assertEqual(len(self.backups()), 1)
        self.env.pop('MOCK_WRITE_FAILURE')
        self.run_setup('--restore', self.backups()[0].name)
        self.assertEqual(self.state()['prefs'], self.initial_prefs)
        self.run_setup('--only', 'macos')
        self.run_setup('--only', 'macos', '--check')

    def test_read_failure_is_not_absence(self):
        self.env['MOCK_READ_FAILURE'] = '1'
        self.run_setup('--only', 'macos', ok=False)
        self.assertFalse(self.state().get('mutations'))

    def test_package_failure_is_nonzero_and_retryable(self):
        self.env['MOCK_BREW_FAILURE'] = '1'
        self.run_setup('--only', 'brew', ok=False)
        self.env.pop('MOCK_BREW_FAILURE')
        self.run_setup('--only', 'brew')
        self.assertEqual((self.home / '.zshrc').read_bytes(), self.original)
        self.assertEqual(self.state()['prefs'], self.initial_prefs)

    def test_symlink_and_damaged_blocks_are_not_overwritten(self):
        target = self.home / '.zprofile'
        target.symlink_to(self.home / '.zshrc')
        self.run_setup('--only', 'shell', ok=False)
        self.assertTrue(target.is_symlink())
        target.unlink()
        target.write_text('# >>> 6uclz1/dotfiles macOS >>>\n')
        self.run_setup('--only', 'shell', ok=False)
        self.assertEqual(self.backups(), [])

    def test_invalid_arguments_root_and_architecture(self):
        for args in (('--only',), ('--restore', '../escape'), ('--dry-run', '--check'), ('--only', 'invalid'), ('--restore', 'abc', '--only', 'shell')):
            self.run_setup(*args, ok=False)
        self.env['MOCK_UID'] = '0'
        self.run_setup('--only', 'macos', ok=False)
        self.env.pop('MOCK_UID')
        self.env['MOCK_ARCH'] = 'x86_64'
        self.run_setup('--only', 'macos', ok=False)
        self.assertFalse(self.state().get('mutations'))

    def test_chflags_failure_is_not_success(self):
        self.env['MOCK_CHFLAGS_FAILURE'] = '1'
        self.run_setup('--only', 'macos', ok=False)

    def test_bootstrap_existing_brew_and_custom_ghq_root(self):
        self.env['GHQ_ROOT'] = str(self.home / 'custom projects')
        self.run_setup(bootstrap=True)
        target = Path(self.env['GHQ_ROOT']) / 'github.com/6uclz1/dotfiles'
        self.assertTrue((target / 'setup.sh').is_file())
        self.run_setup(bootstrap=True)
        self.assertEqual(sum(x[0] == 'ghq' and x[1] == 'get' for x in self.state()['mutations']), 1)
        self.assertFalse(any(x[0] == 'curl' for x in self.state()['mutations']))

    def test_bootstrap_wrong_branch_remote_dirty_checkout(self):
        self.run_setup(bootstrap=True)
        for key, value in [('MOCK_BRANCH', 'master'), ('MOCK_REMOTE', 'https://github.com/other/repo'), ('MOCK_DIRTY', ' M README.md')]:
            self.env[key] = value
            self.run_setup(bootstrap=True, ok=False)
            self.env.pop(key)

    def test_bootstrap_occupied_directory(self):
        target = self.home / 'ghq/github.com/6uclz1/dotfiles'
        target.mkdir(parents=True)
        (target / 'keep').write_text('keep')
        self.run_setup(bootstrap=True, ok=False)
        self.assertEqual((target / 'keep').read_text(), 'keep')

    def test_bootstrap_ghq_failure(self):
        self.env['MOCK_GHQ_FAILURE'] = '1'
        self.run_setup(bootstrap=True, ok=False)

    def test_bootstrap_missing_clt(self):
        state = self.state()
        state['clt'] = False
        self.state_file.write_text(json.dumps(state))
        self.run_setup(bootstrap=True)
        self.assertTrue(self.state()['clt'])
        self.assertIn(['xcode-select', '--install'], self.state()['mutations'])

    def test_bootstrap_clt_failure(self):
        state = self.state()
        state['clt'] = False
        self.state_file.write_text(json.dumps(state))
        self.env['MOCK_CLT_FAILURE'] = '1'
        self.run_setup(bootstrap=True, ok=False)

    def test_bootstrap_without_brew_and_download_failure(self):
        # Skip on machines with the standard brew path: it intentionally wins over PATH.
        if Path('/opt/homebrew/bin/brew').exists(): self.skipTest('Host Homebrew exists')
        (self.bin / 'brew').unlink()
        self.env['MOCK_CURL_FAILURE'] = '1'
        self.run_setup(bootstrap=True, ok=False)
        self.assertFalse((self.bin / 'brew').exists())
        self.env.pop('MOCK_CURL_FAILURE')
        self.env['MOCK_INSTALL_FAILURE'] = '1'
        self.run_setup(bootstrap=True, ok=False)
        self.env.pop('MOCK_INSTALL_FAILURE')
        self.run_setup(bootstrap=True)
        self.assertTrue((self.bin / 'brew').exists())


class NativeMacTests(SetupFixture):
    @unittest.skipUnless(sys.platform == 'darwin', 'Requires macOS defaults/chflags')
    @unittest.skipIf(os.environ.get('DOTFILES_SKIP_NATIVE') == '1', 'Native defaults writes unavailable in this sandbox; must run in macOS CI')
    def test_native_preference_types_and_library_restore(self):
        import plistlib
        prefs = self.base / 'native preferences'
        prefs.mkdir()
        self.env['NATIVE_PREFS'] = str(prefs)
        defaults = self.bin / 'defaults'
        defaults.unlink()
        defaults.write_text('''#!/bin/bash
case "$2" in
  NSGlobalDomain) domain="$NATIVE_PREFS/global" ;;
  com.apple.finder) domain="$NATIVE_PREFS/finder" ;;
  *) exit 91 ;;
esac
operation=$1
shift 2
exec /usr/bin/defaults "$operation" "$domain" "$@"
''')
        defaults.chmod(0o755)
        for command in ('stat', 'chflags'):
            (self.bin / command).unlink()
        def write(domain, key, kind, value):
            subprocess.run([str(defaults), 'write', domain, key, kind, value], env=self.env, check=True)
        write('NSGlobalDomain', 'KeyRepeat', '-int', '6')
        write('NSGlobalDomain', 'com.apple.trackpad.scaling', '-float', '2')
        write('com.apple.finder', 'ShowPathbar', '-string', 'old-value')
        subprocess.run(['/usr/bin/chflags', 'hidden', str(self.home / 'Library')], check=True)
        self.run_setup('--only', 'macos')
        with (prefs / 'global.plist').open('rb') as f: global_values = plistlib.load(f)
        self.assertIs(type(global_values['KeyRepeat']), int)
        self.assertIs(type(global_values['com.apple.mouse.scaling']), float)
        self.assertIs(global_values['AppleShowAllExtensions'], True)
        self.run_setup('--only', 'macos', '--check')
        self.run_setup('--restore', self.backups()[0].name)
        with (prefs / 'global.plist').open('rb') as f: restored = plistlib.load(f)
        self.assertEqual(restored, {'KeyRepeat': 6, 'com.apple.trackpad.scaling': 2.0})
        with (prefs / 'finder.plist').open('rb') as f: restored = plistlib.load(f)
        self.assertEqual(restored, {'ShowPathbar': 'old-value'})
        flags = subprocess.check_output(['/usr/bin/stat', '-f', '%f', str(self.home / 'Library')], text=True)
        self.assertTrue(int(flags) & 32768)

if __name__ == '__main__':
    unittest.main()
