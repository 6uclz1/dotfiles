#!/bin/bash
BEGIN_MARK='# >>> 6uclz1/dotfiles macOS >>>'
END_MARK='# <<< 6uclz1/dotfiles macOS <<<'

validate_shell() {
    [ "${ZDOTDIR:-$HOME}" = "$HOME" ] || fail 'カスタムZDOTDIRは初版の対象外です。HOMEのZsh設定へ統合してください。'
    local name target starts ends
    for name in .zprofile .zshrc; do
        target="$HOME/$name"
        [ ! -L "$target" ] || fail "Zsh設定がsymlinkです。リンク先への統合を先に確認してください: $target"
        if [ -e "$target" ]; then
            [[ -f "$target" && -r "$target" ]] || fail "Zsh設定を読み取れません: $target"
            starts=$(grep -Fxc "$BEGIN_MARK" "$target" || true)
            ends=$(grep -Fxc "$END_MARK" "$target" || true)
            [[ "$starts" = "$ends" && "$starts" -le 1 ]] || fail "管理ブロックが重複・破損しています: $target"
            if [ "$starts" = 1 ]; then
                awk -v b="$BEGIN_MARK" -v e="$END_MARK" '$0==b { s=1 } $0==e { if (!s) exit 1 }' "$target" || fail '管理ブロックの順序が不正です。'
            fi
        fi
    done
}

shell_block() {
    local name=$1 source_file
    case "$name" in .zprofile) source_file=profile.zsh ;; .zshrc) source_file=interactive.zsh ;; esac
    printf '%s\n' "$BEGIN_MARK"
    # Bash %q output is also valid in zsh, including paths with spaces/quotes.
    printf '[[ ! -r %q ]] || source %q\n' "$ROOT/shell/$source_file" "$ROOT/shell/$source_file"
    printf '%s\n' "$END_MARK"
}

existing_block() {
    awk -v b="$BEGIN_MARK" -v e="$END_MARK" '$0==b { s=1 } s { print } $0==e { s=0 }' "$1"
}

apply_shell() {
    local name target expected status
    for name in .zprofile .zshrc; do
        target="$HOME/$name"
        expected=$(shell_block "$name")
        if [ -f "$target" ] && [ "$(existing_block "$target")" = "$expected" ]; then continue; fi
        ensure_backup
        status=absent
        if [ -f "$target" ]; then
            status=present
            cp -p "$target" "$BACKUP/$name.before"
            # Preserve permissions and existing content outside our block.
            cp -p "$target" "$BACKUP/$name.after"
            awk -v b="$BEGIN_MARK" -v e="$END_MARK" '$0==b { s=1; next } $0==e { s=0; next } !s { print }' "$target" > "$BACKUP/$name.after"
        else
            : > "$BACKUP/$name.after"
        fi
        printf '\n%s\n' "$expected" >> "$BACKUP/$name.after"
        printf '%s\n' "$status" > "$BACKUP/$name.status"
        cp -p "$BACKUP/$name.after" "$target"
    done
}

check_shell() {
    local name errors=0
    for name in .zprofile .zshrc; do
        if [ ! -f "$HOME/$name" ] || [ "$(existing_block "$HOME/$name")" != "$(shell_block "$name")" ]; then
            note "未完了: $name の管理ブロック"; errors=1
        fi
    done
    return "$errors"
}
