{ ... }:
{
  imports = [
    ./modules/core.nix
    ./modules/packages.nix
    ./modules/zsh.nix
    ./modules/prompt.nix
    ./modules/vim.nix
  ];
}
