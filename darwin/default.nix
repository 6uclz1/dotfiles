{ pkgs, username, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix manages the daemon and /etc/nix/nix.conf itself, so
  # nix-darwin must not touch them. If you install upstream Nix instead,
  # delete this line and add:
  #   nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;

  system.stateVersion = 7;
  system.primaryUser = username;

  users.users.${username}.home = "/Users/${username}";

  programs.zsh.enable = true;

  environment.systemPackages = [ pkgs.git ];

  homebrew = {
    enable = true; # drives `brew bundle`; Homebrew itself is installed manually
    casks = [
      "visual-studio-code"
      "karabiner-elements"
    ];
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none"; # existing machine: leave undeclared brew packages alone
    };
  };
}
