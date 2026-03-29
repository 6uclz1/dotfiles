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
      macos = import ./hosts/macos;
      wslArch = import ./hosts/wsl-arch;

      mkPkgs = system: import nixpkgs { inherit system; };

      wslConfigName = "${wslArch.username}@${wslArch.hostName}";
    in
    {
      darwinConfigurations = {
        "${macos.configName}" = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            host = macos;
          };

          modules = [
            home-manager.darwinModules.home-manager
            ./darwin/common.nix
            ./darwin/apps.nix
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
        "${macos.system}" =
          let
            pkgs = mkPkgs macos.system;
          in
          {
            macos = self.darwinConfigurations.${macos.configName}.system;
            macos-identifiers = pkgs.runCommand "macos-identifiers" {
              nativeBuildInputs = [ pkgs.ripgrep ];
            } ''
              cd ${self}
              ! rg -n '#MacBook-Air-M4|#macbook-air-m4|hosts/macbook-air-m4|legacy/windows' \
                README.md scripts hosts
              touch "$out"
            '';
          };

        "${wslArch.system}" = {
          wsl-arch = self.homeConfigurations.${wslConfigName}.activationPackage;
        };
      };
    };
}
