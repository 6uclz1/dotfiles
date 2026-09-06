#!/bin/bash
# Private, per-run backups outside the repository. Never execute backup contents.
cleanup_state() {
    local code=$1
    if [ "$LOCKED" = 1 ]; then rmdir "$STATE/lock" || true; fi
    if [ "$code" != 0 ]; then
        printf 'ERROR: 処理未完了（終了コード%s）。バックアップ: %s\n' "$code" "${BACKUP:-なし}" >&2
    fi
    exit "$code"
}

lock_state() {
    umask 077
    [ ! -L "$STATE" ] || fail "バックアップ先がsymlinkです: $STATE"
    [ ! -L "$STATE/backups" ] || fail 'バックアップディレクトリがsymlinkです。'
    mkdir -p "$STATE/backups"
    chmod 700 "$STATE" "$STATE/backups"
    mkdir "$STATE/lock" 2>/dev/null || fail "別の実行が進行中です。異常終了後はREADMEのlock復旧手順を確認してください: $STATE/lock"
    LOCKED=1
}

ensure_backup() {
    if [ -z "$BACKUP" ]; then
        BACKUP=$(mktemp -d "$STATE/backups/$(date +%Y%m%d-%H%M%S).XXXXXX")
        printf '1\n' > "$BACKUP/version"
        note "バックアップID: ${BACKUP##*/}"
    fi
}

restore_state() {
    local backup_id=$1 name target status domain key type value item errors=0
    [[ "$backup_id" =~ ^[0-9]{8}-[0-9]{6}\.[A-Za-z0-9]{6}$ ]] || fail 'バックアップIDが不正です。'
    BACKUP="$STATE/backups/$backup_id"
    [[ -d "$BACKUP" && ! -L "$BACKUP" ]] || fail 'バックアップがありません。'
    [ "$(cat "$BACKUP/version")" = 1 ] || fail 'バックアップ形式が不明です。'
    # Check every shell conflict before restoring anything. Never erase later edits.
    for name in .zprofile .zshrc; do
        [ -f "$BACKUP/$name.status" ] || continue
        target="$HOME/$name"
        [ ! -L "$target" ] || fail "復元先がsymlinkです: $target"
        if [ -e "$target" ]; then
            if ! cmp -s "$target" "$BACKUP/$name.after" && ! cmp -s "$target" "$BACKUP/$name.before"; then
                fail "セットアップ後の編集があります。バックアップと比較して手動で統合してください: $target"
            fi
        elif [ "$(cat "$BACKUP/$name.status")" != absent ]; then
            fail "復元先が削除されています。手動で確認してください: $target"
        fi
    done
    for name in .zprofile .zshrc; do
        [ -f "$BACKUP/$name.status" ] || continue
        target="$HOME/$name"
        status=$(cat "$BACKUP/$name.status")
        case "$status" in
            present) cp -p "$BACKUP/$name.before" "$target" ;;
            absent) rm -f "$target" ;;
            *) fail 'ファイルのバックアップ形式が不正です。' ;;
        esac
    done
    if [ -f "$BACKUP/preferences.tsv" ]; then
        while IFS=$'\t' read -r item domain key; do
            [[ "$item" =~ ^[0-9]+$ ]] || fail '設定バックアップが不正です。'
            validate_key "$domain" "$key" || fail '復元対象外の設定キーです。'
            type=$(cat "$BACKUP/pref-$item.type")
            if [ "$type" = absent ]; then
                read_preference "$domain" "$key"
                if [ "$PREF_TYPE" != absent ]; then defaults delete "$domain" "$key"; fi
            else
                case "$type" in int|float|bool|string) ;; *) fail '復元する型が不正です。' ;; esac
                value=$(cat "$BACKUP/pref-$item.value")
                defaults write "$domain" "$key" "-$type" "$value"
            fi
            read_preference "$domain" "$key"
            if [ "$PREF_TYPE" != "$type" ]; then errors=1
            elif [ "$type" != absent ] && ! values_equal "$type" "$PREF_VALUE" "$value"; then errors=1; fi
        done < "$BACKUP/preferences.tsv"
    fi
    if [ -f "$BACKUP/library-hidden" ]; then
        value=$(cat "$BACKUP/library-hidden")
        case "$value" in true) chflags hidden "$HOME/Library" ;; false) chflags nohidden "$HOME/Library" ;; *) fail 'Libraryのバックアップが不正です。' ;; esac
        [ "$(library_hidden)" = "$value" ] || errors=1
    fi
    [ "$errors" = 0 ] || fail '一部の設定を復元できませんでした。'
}
