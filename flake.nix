{
  description = "Alice's Mac mini configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    nix-darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, ... }: {
    # This is a flake selector, not the macOS hostname. The flake deliberately
    # leaves ComputerName, HostName, and LocalHostName unmanaged.
    darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        inputs.determinate.darwinModules.default
        ./configuration.nix
      ];
    };
  };
}
