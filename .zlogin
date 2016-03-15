###############################################################################
# ZLOGIN
###############################################################################

# Execute code that does not affect the current session in the background.
{
    # Compile the completion dump to increase startup speed.
    # zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    zcompdump="$HOME/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        echo "Run zcompile $zcompdump in the background ..."
        zcompile "$zcompdump"
    fi
} &!

# Dupricate delete
typeset -U path cdpath fpath manpath

fpath=(/usr/local/share/zsh-completions $fpath)

export fpath

echo "Good Morning!"
