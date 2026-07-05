{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;

    # zsh-autocomplete runs its own compinit and must be sourced before any
    # compinit/compdef, so home-manager's compinit (order 570) is disabled
    # and the plugin goes first in `plugins` (sourced at order 900).
    enableCompletion = false;
    # The autosuggestion toggle would source at order 700, before
    # zsh-autocomplete; managed via `plugins` instead to keep the order.
    autosuggestion.enable = false;
    # home-manager sources this at the very end of .zshrc (order 1200),
    # which is exactly where zsh-syntax-highlighting must go.
    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.cacheHome}/zsh_history";
      size = 1000000;
      save = 1000000;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
    };

    setOptions = [
      "AUTO_CD"
      "AUTO_MENU"
      "AUTO_PUSHD"
      "HIST_VERIFY"
      "HIST_REDUCE_BLANKS"
      "LIST_PACKED"
      "LIST_TYPES"
      "NO_BEEP"
    ];

    localVariables.REPORTTIME = 3;

    shellAliases.v = "nvim";

    # Sourced in this exact order.
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
        file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = lib.mkMerge [
      # Powerlevel10k instant prompt: must stay at the very top of .zshrc.
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkOrder 1000 ''
        # Homebrew is intentionally not Nix-managed; put brew on PATH.
        [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

        # p10k user config stays untracked; generate it with `p10k configure`.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '')
    ];
  };
}
