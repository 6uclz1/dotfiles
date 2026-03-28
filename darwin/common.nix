{ inputs, pkgs, host, ... }:
{
  networking.hostName = host.hostName;

  nixpkgs.hostPlatform = host.system;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  environment.shells = [
    pkgs.zsh
  ];

  users.users.${host.username} = {
    home = host.homeDirectory;
    shell = pkgs.zsh;
  };

  system.primaryUser = host.username;
  system.configurationRevision =
    if inputs.self ? rev then
      inputs.self.rev
    else if inputs.self ? dirtyRev then
      inputs.self.dirtyRev
    else
      null;
  system.stateVersion = 6;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit host;
  };
  home-manager.users.${host.username} = import ../home/common.nix;
}
