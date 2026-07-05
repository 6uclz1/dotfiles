# dotfiles

macOS (Apple Silicon) configuration, declaratively managed with
[Nix](https://nixos.org/) + [nix-darwin](https://github.com/nix-darwin/nix-darwin) +
[home-manager](https://github.com/nix-community/home-manager), flake-based.

- **darwin/** — system layer: Homebrew casks (VS Code, Karabiner-Elements), system settings
- **home/** — user layer: zsh (Powerlevel10k, autocomplete, autosuggestions, syntax highlighting), Neovim, CLI packages
- **config/nvim/** — [LazyVim](https://www.lazyvim.org/) config (plugins managed by lazy.nvim, pinned via `lazy-lock.json`)

The repo is expected to be checked out at `~/dotfiles`
(`home/neovim.nix` symlinks `~/.config/nvim` to `~/dotfiles/config/nvim`).

## Bootstrap (fresh Mac)

1. Xcode Command Line Tools:

   ```sh
   xcode-select --install
   ```

2. Homebrew (nix-darwin drives `brew bundle` but does not install Homebrew itself):

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Nix, via the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
   (survives macOS upgrades, clean uninstall, flakes enabled by default):

   ```sh
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```

   > This installs **Determinate Nix**, which manages the Nix daemon itself —
   > that is why `darwin/default.nix` sets `nix.enable = false;`.
   > If you use upstream Nix instead, delete that line and add
   > `nix.settings.experimental-features = "nix-command flakes";`.

4. Clone and adjust identity:

   ```sh
   git clone https://github.com/6uclz1/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

   Set `username` (`whoami`) and `hostname` (`scutil --get LocalHostName`)
   in `flake.nix`.

5. First activation (`darwin-rebuild` is not on PATH yet):

   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles
   ```

   Troubleshooting:
   - `/etc/zshrc` already exists → `sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin`
   - nixbld GID mismatch → add `ids.gids.nixbld = 350;` to `darwin/default.nix`

6. Open a new terminal, then:
   - `p10k configure` — generates the untracked `~/.p10k.zsh`
   - run `nvim` once — lazy.nvim bootstraps and installs plugins
     (`:Lazy restore` reproduces the exact revisions from `lazy-lock.json`);
     commit `lazy-lock.json` if it changed

## Daily workflow

```sh
# apply config changes
sudo darwin-rebuild switch --flake ~/dotfiles

# update all inputs (nixpkgs, nix-darwin, home-manager), then apply
nix flake update && sudo darwin-rebuild switch --flake ~/dotfiles
# commit flake.lock afterwards

# update neovim plugins deliberately, then commit lazy-lock.json
nvim +Lazy update
```

Rollback:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild switch --rollback
```

## Migrating from the old (pre-Nix) setup

```sh
rm -f ~/.zshrc ~/.zshenv ~/.vimrc   # old symlinks into this repo
rm -rf ~/.zsh                       # git-cloned zsh plugins, now from nixpkgs
```

`~/.p10k.zsh` and `~/.cache/zsh_history` keep working unchanged. The
brew-installed `powerlevel10k` formula is removed automatically on the first
switch (`homebrew.onActivation.cleanup = "uninstall"`); optional tidy-up:
`brew untap homebrew/cask`, delete `~/.vim` and `~/.cache/dein`.

## Untracked by design

- `~/.p10k.zsh` — personal prompt tuning, regenerate with `p10k configure`
- `~/.local/share/nvim/lazy/` — lazy.nvim's plugin store. Nix guarantees the
  nvim binary, CLI dependencies and config files; plugin revisions are pinned
  by the tracked `lazy-lock.json`.
