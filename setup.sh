#!/bin/bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
# shellcheck source=bootstrap.sh
source "$ROOT/bootstrap.sh"
# shellcheck source=scripts/state.sh
source "$ROOT/scripts/state.sh"
# shellcheck source=scripts/shell.sh
source "$ROOT/scripts/shell.sh"
# shellcheck source=scripts/macos.sh
source "$ROOT/scripts/macos.sh"

usage() {
    note '使い方: ./setup.sh [--only brew|shell|macos] [--dry-run|--check]'
    note '        ./setup.sh --restore <バックアップID>'
}
ONLY=all MODE=apply RESTORE_ID='' BACKUP='' LOCKED=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --only) [ "$#" -ge 2 ] && [ "$ONLY" = all ] || fail '--onlyの指定が不正です。'
            ONLY=$2; shift
            case "$ONLY" in brew|shell|macos) ;; *) fail '--onlyはbrew/shell/macosです。' ;; esac ;;
        --dry-run|--check) [ "$MODE" = apply ] || fail '操作モードは1つだけ指定してください。'; MODE=${1#--} ;;
        --restore) [ "$#" -ge 2 ] && [ "$MODE" = apply ] || fail '--restoreの指定が不正です。'
            MODE=restore; RESTORE_ID=$2; shift ;;
        --help|-h) usage; exit 0 ;;
        *) usage; fail "不明な引数: $1" ;;
    esac
    shift
done
[ "$MODE" != restore ] || [ "$ONLY" = all ] || fail '--restoreと--onlyは併用できません。'
preflight
STATE="$HOME/Library/Application Support/6uclz1-dotfiles"
trap 'cleanup_state "$?"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if [ "$MODE" = restore ]; then
    lock_state
    restore_state "$RESTORE_ID"
    note '復元完了。Zshは新しいターミナル、macOS設定は再ログイン後に確認してください。'
    exit 0
fi
if [ "$ONLY" = all ] || [ "$ONLY" = macos ]; then validate_settings; fi
if [ "$ONLY" = all ] || [ "$ONLY" = shell ]; then validate_shell; fi
if [ "$MODE" = dry-run ]; then
    if [ "$ONLY" = all ] || [ "$ONLY" = brew ]; then
        note '予定: Command Line Tools/Homebrewを確認し、Brewfileの不足分を導入（--no-upgrade）。'
        cat "$ROOT/Brewfile"
    fi
    if [ "$ONLY" = all ] || [ "$ONLY" = shell ]; then note '予定: ~/.zprofile・~/.zshrcに管理ブロックを追加。変更前にバックアップ。'; fi
    if [ "$ONLY" = all ] || [ "$ONLY" = macos ]; then cat "$ROOT/config/macos.tsv"; fi
    note 'dry-run完了。書き込み・インストール・ネットワークアクセスなし。'
    exit 0
fi
check_all() {
    local errors=0
    if [ "$ONLY" = all ] || [ "$ONLY" = brew ]; then
        if find_brew; then
            if ! HOMEBREW_NO_AUTO_UPDATE=1 "$BREW" bundle check --no-upgrade --file="$ROOT/Brewfile"; then errors=1; fi
        else note '未完了: Homebrew'; errors=1; fi
        if ! xcode-select -p >/dev/null 2>&1 || ! xcrun --find clang >/dev/null 2>&1; then note '未完了: Command Line Tools'; errors=1; fi
    fi
    if [ "$ONLY" = all ] || [ "$ONLY" = shell ]; then check_shell || errors=1; fi
    if [ "$ONLY" = all ] || [ "$ONLY" = macos ]; then check_macos || errors=1; fi
    return "$errors"
}
if [ "$MODE" = check ]; then
    check_all
    note '保存済み設定の検証成功。操作感とFinderの表示は再ログイン後に実機確認してください。'
    exit 0
fi
lock_state
if [ "$ONLY" = all ] || [ "$ONLY" = brew ]; then
    ensure_clt
    ensure_brew
    "$BREW" bundle install --no-upgrade --file="$ROOT/Brewfile"
    note '成功: Homebrew / CLI'
fi
if [ "$ONLY" = all ] || [ "$ONLY" = shell ]; then apply_shell; note '成功: Zsh'; fi
if [ "$ONLY" = all ] || [ "$ONLY" = macos ]; then apply_macos; note '成功: macOS設定'; fi
check_all
note "設定・導入の検証完了。バックアップ: ${BACKUP:-変更なし}"
note '手動: 新しいターミナルを開き、再ログイン後にFinder・入力速度を確認してください。'
note 'GitHubの認証は必要に応じて gh auth login を実行してください。'
