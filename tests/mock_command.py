"""External commands for isolated tests. No real installs or system preferences."""
import json
import os
from pathlib import Path
import shutil
import sys

name = Path(sys.argv[0]).name
args = sys.argv[1:]
state_path = Path(os.environ['MOCK_STATE'])
state = json.loads(state_path.read_text())

def save():
    state_path.write_text(json.dumps(state))

def stop(code=1):
    sys.exit(code)

def mutation():
    state.setdefault('mutations', []).append([name, *args])
    save()

if name == 'uname':
    print('Darwin' if args == ['-s'] else os.environ.get('MOCK_ARCH', 'arm64'))
elif name == 'id':
    print(os.environ.get('MOCK_UID', '501') if args == ['-u'] else 'fixture')
elif name == 'sw_vers':
    print('26.0')
elif name in ('xcode-select', 'xcrun'):
    if args == ['--install']:
        mutation()
        if os.environ.get('MOCK_CLT_FAILURE'): stop()
        state['clt'] = True
        save()
    elif not state.get('clt', True): stop()
    else: print('/mock/CLT')
elif name == 'sleep':
    stop(0)
elif name == 'curl':
    mutation()
    if os.environ.get('MOCK_CURL_FAILURE'): stop(22)
    output = Path(args[args.index('-o') + 1])
    output.write_text('exit 9\n' if os.environ.get('MOCK_INSTALL_FAILURE') else
                      'ln -s "$MOCK_ENGINE" "$MOCK_BIN/brew"\n')
elif name == 'brew':
    if args == ['shellenv']:
        print('export HOMEBREW_PREFIX="/mock/homebrew"')
    elif args[:2] == ['list', '--versions']:
        stop(0 if args[2] in state.get('packages', []) else 1)
    elif args[0] == 'install':
        mutation()
        if os.environ.get('MOCK_BREW_FAILURE'): stop()
        state.setdefault('packages', []).append(args[1])
        save()
    elif args[:2] in (['bundle', 'install'], ['bundle', 'check']):
        assert '--no-upgrade' in args
        brewfile = Path(next(x.split('=', 1)[1] for x in args if x.startswith('--file=')))
        packages = [line.split('"')[1] for line in brewfile.read_text().splitlines() if line.startswith('brew ')]
        if args[1] == 'install':
            mutation()
            assert os.environ.get('HOMEBREW_NO_AUTO_UPDATE') == '1'
            assert os.environ.get('HOMEBREW_NO_INSTALL_CLEANUP') == '1'
            if os.environ.get('MOCK_BREW_FAILURE'): stop()
            state['packages'] = sorted(set(state.get('packages', []) + packages))
            save()
        else: stop(0 if set(packages) <= set(state.get('packages', [])) else 1)
    else: raise AssertionError(args)
elif name == 'ghq':
    root = Path(os.environ.get('GHQ_ROOT', str(Path(os.environ['HOME']) / 'ghq')))
    repo = root / 'github.com/6uclz1/dotfiles'
    if args[0] == 'root': print(root)
    elif args[0] == 'list':
        if (repo / '.git').exists(): print(repo)
    elif args[0] == 'get':
        mutation()
        assert '--no-recursive' in args and '--branch' in args
        if os.environ.get('MOCK_GHQ_FAILURE'): stop()
        shutil.copytree(os.environ['MOCK_REPO'], repo, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        (repo / '.git').mkdir()
    else: raise AssertionError(args)
elif name == 'git':
    if args[0] == 'check-ref-format': stop(0)
    assert args[0] == '-C'
    repo = args[1]
    cmd = args[2:]
    if cmd == ['rev-parse', '--show-toplevel']: print(repo)
    elif cmd == ['remote', 'get-url', 'origin']: print(os.environ.get('MOCK_REMOTE', 'https://github.com/6uclz1/dotfiles.git'))
    elif cmd == ['symbolic-ref', '--short', 'HEAD']: print(os.environ.get('MOCK_BRANCH', 'macOS'))
    elif cmd == ['status', '--porcelain']: print(os.environ.get('MOCK_DIRTY', ''), end='')
    else: raise AssertionError(args)
elif name == 'defaults':
    cmd, domain, key = args[:3]
    prefs = state.setdefault('prefs', {})
    pref = domain + '/' + key
    if cmd.startswith('read'):
        if os.environ.get('MOCK_READ_FAILURE'):
            print('Permission denied', file=sys.stderr)
            stop()
        if pref not in prefs:
            print('The domain/default pair does not exist', file=sys.stderr)
            stop()
        kind, value = prefs[pref]
        if cmd == 'read-type': print('Type is ' + {'int': 'integer', 'bool': 'boolean', 'float': 'float', 'string': 'string'}[kind])
        else: print(value)
    elif cmd == 'write':
        mutation()
        if key == os.environ.get('MOCK_WRITE_FAILURE'): stop()
        kind, value = args[3][1:], args[4]
        if kind == 'bool': value = '1' if value in ('true', '1', 'YES') else '0'
        prefs[pref] = [kind, value]
        save()
    elif cmd == 'delete':
        mutation()
        if pref not in prefs: stop()
        del prefs[pref]
        save()
    else: raise AssertionError(args)
elif name == 'stat':
    assert args[:2] == ['-f', '%f']
    print(32768 if state.get('hidden', True) else 0)
elif name == 'chflags':
    mutation()
    if os.environ.get('MOCK_CHFLAGS_FAILURE'): stop()
    state['hidden'] = args[0] == 'hidden'
    save()
else:
    raise AssertionError((name, args))
