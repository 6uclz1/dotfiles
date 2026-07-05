{ config, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # Keep home-manager from generating ~/.config/nvim/init.lua (provider
    # setup); it would collide with the whole-directory symlink below.
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
  };

  # home-manager always emits a provider-setup init.lua; it would collide
  # with the whole-directory symlink below. The provider flags live in
  # config/nvim/lua/config/options.lua instead.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  # Live symlink into the repo checkout so lazy.nvim can write lazy-lock.json
  # back into the repo. Assumes the repo is checked out at ~/dotfiles.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
}
