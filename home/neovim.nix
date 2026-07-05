{ config, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Live symlink into the repo checkout so lazy.nvim can write lazy-lock.json
  # back into the repo. Assumes the repo is checked out at ~/dotfiles.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
}
