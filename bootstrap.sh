#!/bin/bash
# Standalone entry point; setup.sh also sources these prerequisite functions.
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
note() { printf '%s\n' "$*"; }

preflight() {
    [ "$(uname -s)" = Darwin ] || fail 'macOSで実行してください。'
    [ "$(uname -m)" = arm64 ] || fail '初版はApple Siliconのネイティブシェルが対象です。'
    [ "$(id -u)" != 0 ] || fail 'sudoで全体を実行せず、通常ユーザーで実行してください。'
    [ -n "${HOME:-}" ] && [ -d "$HOME" ] || fail 'HOMEが利用できません。'
    case "$HOME" in /*) ;; *) fail 'HOMEは絶対パスで指定してください。' ;; esac
    note "macOS $(sw_vers -productVersion) / $(uname -m) / $(id -un)"
}

ensure_clt() {
    if xcode-select -p >/dev/null 2>&1 && xcrun --find clang >/dev/null 2>&1; then return; fi
    note 'Command Line Toolsの導入画面を開きます。完了まで待ちます（最大30分）。'
    xcode-select --install || fail '導入画面を開けません。Command Line Toolsを手動で導入後、再実行してください。'
    local attempt
    for ((attempt=0; attempt<180; attempt++)); do
        if xcode-select -p >/dev/null 2>&1 && xcrun --find clang >/dev/null 2>&1; then return; fi
        sleep 10
    done
    fail 'Command Line Toolsを確認できません。導入完了後、同じコマンドを再実行してください。'
}

find_brew() {
    BREW=$(command -v brew || true)
    if [ -z "$BREW" ] && [ -x /opt/homebrew/bin/brew ]; then BREW=/opt/homebrew/bin/brew; fi
    [ -n "$BREW" ]
}

activate_brew() {
    local shellenv
    shellenv=$("$BREW" shellenv) || fail 'Homebrewの環境を読み込めません。'
    eval "$shellenv"
    export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
}

ensure_brew() {
    if ! find_brew; then
        local installer
        installer=$(mktemp -t dotfiles-homebrew)
        if ! curl --fail --silent --show-error --location --retry 3 \
            https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"; then
            rm -f "$installer"
            fail 'Homebrewインストーラーの取得に失敗しました。'
        fi
        if ! /bin/bash "$installer"; then
            rm -f "$installer"
            fail 'Homebrew導入に失敗しました。同じコマンドで再実行できます。'
        fi
        rm -f "$installer"
        find_brew || fail 'Homebrewの導入後確認に失敗しました。'
    fi
    activate_brew
}

validate_checkout() {
    local directory=$1 branch=$2 remote current top checkout_status
    [ -d "$directory/.git" ] || [ -f "$directory/.git" ] || fail "Git管理外の保存先です: $directory"
    top=$(git -C "$directory" rev-parse --show-toplevel) || fail 'リポジトリを確認できません。'
    [ "$(cd "$directory" && pwd -P)" = "$(cd "$top" && pwd -P)" ] || fail '保存先がリポジトリのルートではありません。'
    remote=$(git -C "$directory" remote get-url origin) || fail 'originがありません。'
    case "$remote" in
        https://github.com/6uclz1/dotfiles|https://github.com/6uclz1/dotfiles.git|git@github.com:6uclz1/dotfiles|git@github.com:6uclz1/dotfiles.git) ;;
        *) fail "別のリポジトリが保存先にあります: $directory" ;;
    esac
    current=$(git -C "$directory" symbolic-ref --short HEAD) || fail 'detached HEADの保存先です。'
    [ "$current" = "$branch" ] || fail "保存先は $current ブランチです。自動切替しません: $directory"
    checkout_status=$(git -C "$directory" status --porcelain) || fail '作業ツリーの状態を確認できません。'
    [ -z "$checkout_status" ] || fail "未コミット変更があります: $directory"
}

bootstrap_main() {
    set -euo pipefail
    trap 'printf "ERROR: bootstrapが中断しました。原因を解消して再実行してください。\n" >&2' ERR
    case "${1:-}" in
        --dry-run) [ "$#" = 1 ] || fail '使い方: bootstrap.sh [--dry-run]'
            preflight
            note '予定: Command Line Tools → Homebrew → git/ghq → ghq get --branch macOS → setup.sh'
            note 'ghq.root/GHQ_ROOTを尊重します。設定・ファイル・ネットワークに変更は行いません。'
            return ;;
        '') [ "$#" = 0 ] || fail '使い方: bootstrap.sh [--dry-run]' ;;
        *) fail '使い方: bootstrap.sh [--dry-run]' ;;
    esac
    preflight
    ensure_clt
    ensure_brew
    local tool branch directory matches root roots
    for tool in git ghq; do
        if ! "$BREW" list --versions "$tool" >/dev/null 2>&1; then "$BREW" install "$tool"; fi
    done
    branch=${DOTFILES_BRANCH:-macOS}
    git check-ref-format --branch "$branch" >/dev/null || fail 'ブランチ名が不正です。'
    matches=$(ghq list --full-path --exact github.com/6uclz1/dotfiles)
    if [ -n "$matches" ]; then
        case "$matches" in *$'\n'*) fail 'ghq内に複数のdotfilesがあります。対象をGHQ_ROOTで指定してください。' ;; esac
        directory=$matches
        validate_checkout "$directory" "$branch"
        note '既存のcheckoutを使います。自動pullは行いません。'
    else
        roots=$(ghq root --all) || fail 'ghqの保存先を読み取れません。'
        while IFS= read -r root; do
            directory="$root/github.com/6uclz1/dotfiles"
            if [ -e "$directory" ] || [ -L "$directory" ]; then fail "保存先がすでに存在します: $directory"; fi
        done <<< "$roots"
        ghq get --no-recursive --branch "$branch" https://github.com/6uclz1/dotfiles.git
        directory=$(ghq list --full-path --exact github.com/6uclz1/dotfiles)
        [ -n "$directory" ] || fail 'ghqで取得した保存先を確認できません。'
        case "$directory" in *$'\n'*) fail '取得先を一意に決められません。' ;; esac
        validate_checkout "$directory" "$branch"
    fi
    [ -f "$directory/setup.sh" ] || fail 'このcheckoutにはsetup.shがありません。macOSブランチへの公開状況を確認してください。'
    note "ghq管理先: $directory"
    /bin/bash "$directory/setup.sh"
}
if [ "${BASH_SOURCE[0]:-$0}" = "$0" ]; then bootstrap_main "$@"; fi
