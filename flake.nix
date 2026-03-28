{
  description = "Declarative dotfiles for macOS and WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      macbook = import ./hosts/macbook-air-m4;
      wslArch = import ./hosts/wsl-arch;

      mkPkgs = system: import nixpkgs { inherit system; };

      wslConfigName = "${wslArch.username}@${wslArch.hostName}";
    in
    {
      darwinConfigurations = {
        "${macbook.hostName}" = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            host = macbook;
          };

          modules = [
            home-manager.darwinModules.home-manager
            ./darwin/common.nix
          ];
        };
      };

      homeConfigurations = {
        "${wslConfigName}" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs wslArch.system;

          extraSpecialArgs = {
            inherit inputs;
            host = wslArch;
          };

          modules = [
            ./home/common.nix
          ];
        };
      };

      checks = {
        "${macbook.system}" = {
          macbook-air-m4 = self.darwinConfigurations.${macbook.hostName}.system;
        };

        "${wslArch.system}" = {
          wsl-arch = self.homeConfigurations.${wslConfigName}.activationPackage;
        };
      };
    };
}
