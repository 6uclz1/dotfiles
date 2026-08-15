{ pkgs, ... }:

{
  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  environment = {
    systemPackages = with pkgs; [
      neovim
      peco
      zsh-powerlevel10k
    ];

    shellAliases = {
      cat = "bat --paging=never";
      l = "eza --group-directories-first";
      la = "eza --all --group-directories-first";
      ll = "eza --long --all --git --group-directories-first";
      lt = "eza --tree --level=2 --group-directories-first";
      lg = "lazygit";
      v = "nvim";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;

    histFile = "$HOME/.zsh_history";
    histSize = 1000000;

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      HOMEBREW_NO_ANALYTICS = "1";
    };

    interactiveShellInit = ''
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt EXTENDED_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt INTERACTIVE_COMMENTS
      setopt NO_BEEP
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      REPORTTIME=3

      # Select a repository managed by ghq and move to it. The current command
      # line is used as peco's initial query, following the referenced workflow.
      function g() {
        local selected_dir
        selected_dir="$(ghq list --full-path | peco --query "$LBUFFER")" || return
        [[ -n "$selected_dir" ]] && builtin cd -- "$selected_dir"
      }

      eval "$(zoxide init zsh)"
    '';

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -r "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
    '';
  };
}
