{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = false;

    autocd = true;

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 1000000;
      save = 1000000;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      extended = true;
      share = false;
    };

    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };

    syntaxHighlighting.enable = true;

    setOptions = [
      "AUTO_MENU"
      "AUTO_PUSHD"
      "HIST_REDUCE_BLANKS"
      "HIST_VERIFY"
      "LIST_PACKED"
      "LIST_TYPES"
      "NO_BEEP"
    ];

    initContent = lib.mkOrder 550 ''
      fpath+=(
        ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/Functions
        ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/Completions
      )
      source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    '';
  };
}
