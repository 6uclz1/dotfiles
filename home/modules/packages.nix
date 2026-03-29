{ lib, pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      cargo
      eza
      fastfetch
      fd
      ffmpeg
      fzf
      gh
      ghq
      help2man
      imagemagick
      jq
      lazygit
      neovim
      p7zip
      pandoc
      peco
      poppler
      resvg
      ripgrep
      rustc
      tmux
      uv
      volta
      yazi
      zellij
      zoxide
    ])
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
      xcodegen
    ]);
}
