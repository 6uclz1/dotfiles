{ pkgs, username, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    HOMEBREW_NO_ANALYTICS = "1";
    CLICOLOR = "1";
    LSCOLORS = "exfxcxdxbxGxDxabagacad";
    LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:";
  };

  # LazyVim runtime dependencies
  home.packages = with pkgs; [
    ripgrep
    fd
    lazygit
  ];

  programs.home-manager.enable = true;
}
