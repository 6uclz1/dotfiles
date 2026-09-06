#!/bin/bash
validate_key() {
    case "$1/$2" in
        NSGlobalDomain/KeyRepeat|NSGlobalDomain/InitialKeyRepeat|NSGlobalDomain/com.apple.mouse.scaling|NSGlobalDomain/com.apple.trackpad.scaling|NSGlobalDomain/AppleShowAllExtensions|com.apple.finder/AppleShowAllFiles|com.apple.finder/ShowPathbar|com.apple.finder/ShowStatusBar) return 0 ;;
        *) return 1 ;;
    esac
}

validate_settings() {
    local domain key type value extra seen='|' expected
    while IFS=$'\t' read -r domain key type value extra; do
        case "$domain" in ''|'#'*) continue ;; esac
        [[ -z "$extra" && -n "$value" ]] || fail 'macos.tsvの列が不正です。'
        case "$seen" in *"|$domain/$key|"*) fail '設定キーが重複しています。' ;; esac
        seen="$seen$domain/$key|"
        if [ "$domain/$key" != filesystem/LibraryHidden ]; then validate_key "$domain" "$key" || fail "管理対象外: $domain/$key"; fi
        case "$key" in KeyRepeat|InitialKeyRepeat) expected=int ;; *.scaling) expected=float ;; *) expected=bool ;; esac
        [ "$type" = "$expected" ] || fail "設定型が不正です: $key"
        case "$type" in
            int) [[ "$value" =~ ^[1-9][0-9]*$ ]] || fail "${key}には正の整数を指定してください。" ;;
            float) [[ "$value" =~ ^[0-9]+(\.[0-9]+)?$ ]] || fail "${key}には0以上の数値を指定してください。" ;;
            bool) case "$value" in true|false) ;; *) fail "${key}にはtrue/falseを指定してください。" ;; esac ;;
        esac
    done < "$ROOT/config/macos.tsv"
    [[ -d "$HOME/Library" && ! -L "$HOME/Library" ]] || fail 'ユーザーLibraryがありません、またはsymlinkです。'
}

read_preference() {
    local output
    PREF_VALUE=
    if output=$(LC_ALL=C defaults read-type "$1" "$2" 2>&1); then
        case "$output" in
            *'Type is integer'*) PREF_TYPE=int ;;
            *'Type is float'*) PREF_TYPE=float ;;
            *'Type is boolean'*) PREF_TYPE=bool ;;
            *'Type is string'*) PREF_TYPE=string ;;
            *) fail "未対応の既存設定型: $1/$2 ($output)" ;;
        esac
        PREF_VALUE=$(defaults read "$1" "$2") || fail "設定値を読み取れません: $1/$2"
    else
        case "$output" in
            *'does not exist'*) PREF_TYPE=absent ;;
            *) fail "設定型を読み取れません: $1/$2 ($output)" ;;
        esac
    fi
}

values_equal() {
    case "$1" in
        bool)
            local left=$2 right=$3
            case "$left" in 1|true|YES) left=true ;; 0|false|NO) left=false ;; esac
            case "$right" in 1|true|YES) right=true ;; 0|false|NO) right=false ;; esac
            [ "$left" = "$right" ] ;;
        float|int) awk -v a="$2" -v b="$3" 'BEGIN { exit !(a+0 == b+0) }' ;;
        *) [ "$2" = "$3" ] ;;
    esac
}

library_hidden() {
    local flags
    flags=$(stat -f '%f' "$HOME/Library") || fail 'Libraryの表示状態を取得できません。'
    if (( (flags & 32768) != 0 )); then printf 'true\n'; else printf 'false\n'; fi
}

apply_macos() {
    local domain key type value item=0 current_hidden
    while IFS=$'\t' read -r domain key type value; do
        case "$domain" in ''|'#'*) continue ;; esac
        if [ "$domain" = filesystem ]; then
            current_hidden=$(library_hidden) || fail 'Libraryの状態を取得できません。'
            if [ "$current_hidden" != "$value" ]; then
                ensure_backup
                printf '%s\n' "$current_hidden" > "$BACKUP/library-hidden"
                if [ "$value" = true ]; then chflags hidden "$HOME/Library"; else chflags nohidden "$HOME/Library"; fi
            fi
            continue
        fi
        read_preference "$domain" "$key"
        if [ "$PREF_TYPE" = "$type" ] && values_equal "$type" "$PREF_VALUE" "$value"; then continue; fi
        ensure_backup
        item=$((item+1))
        printf '%s\n' "$PREF_TYPE" > "$BACKUP/pref-$item.type"
        printf '%s' "$PREF_VALUE" > "$BACKUP/pref-$item.value"
        printf '%s\t%s\t%s\n' "$item" "$domain" "$key" >> "$BACKUP/preferences.tsv"
        defaults write "$domain" "$key" "-$type" "$value"
    done < "$ROOT/config/macos.tsv"
}

check_macos() {
    local domain key type value errors=0
    while IFS=$'\t' read -r domain key type value; do
        case "$domain" in ''|'#'*) continue ;; esac
        if [ "$domain" = filesystem ]; then
            if [ "$(library_hidden)" != "$value" ]; then note '未完了: Libraryの表示'; errors=1; fi
        else
            read_preference "$domain" "$key"
            if [ "$PREF_TYPE" != "$type" ] || ! values_equal "$type" "$PREF_VALUE" "$value"; then
                note "未完了: $domain/${key}（期待値: $value / 現在: ${PREF_VALUE:-未設定}）"; errors=1
            fi
        fi
    done < "$ROOT/config/macos.tsv"
    return "$errors"
}
