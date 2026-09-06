[[ -o interactive ]] || return
# Keep existing custom history paths and larger history limits.
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
(( HISTSIZE >= 10000 )) || HISTSIZE=10000
(( SAVEHIST >= 10000 )) || SAVEHIST=10000
setopt APPEND_HISTORY HIST_IGNORE_DUPS
if (( ! $+functions[compdef] )); then
  autoload -Uz compinit
  compinit
fi

# Select a ghq-managed repository. Cancellation leaves the directory unchanged.
function cghq() {
  local directory
  (( $+commands[ghq] && $+commands[fzf] )) || return 1
  directory=$(ghq list --full-path | fzf) || return 0
  [[ -n $directory ]] && builtin cd -- "$directory"
}
