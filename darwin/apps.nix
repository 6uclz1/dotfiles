{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brave
    ghostty-bin
    google-chrome
    vscode
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

  # Expose GUI apps in Finder and Spotlight from a stable application folder.
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up /Applications/Nix Apps..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r src; do
      app_name="$(basename "$src")"
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done
  '';
}
