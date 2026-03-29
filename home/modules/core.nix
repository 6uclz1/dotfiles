{ host, ... }:
let
  homeDir = host.homeDirectory;
in
{
  home = {
    username = host.username;
    homeDirectory = homeDir;
    stateVersion = "25.11";

    sessionPath = [
      "${homeDir}/.local/bin"
      "${homeDir}/bin"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ];

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      REPORTTIME = "3";
      CLICOLOR = "1";
      LSCOLORS = "exfxcxdxbxGxDxabagacad";
      LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01";
    };
  };

  xdg.enable = true;

  programs.home-manager.enable = true;
}
