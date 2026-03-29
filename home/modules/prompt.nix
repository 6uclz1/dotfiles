{ lib, pkgs, ... }:
{
  home.file.".p10k.zsh".source = ../../files/p10k.zsh;

  programs.zsh.initContent = lib.mkMerge [
    (lib.mkOrder 500 ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '')

    (lib.mkOrder 505 ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '')
  ];
}
