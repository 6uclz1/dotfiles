# dotfiles

Nix を唯一の設定ソースにした dotfiles です。Phase 1 では macOS の `MacBook-Air-M4` と WSL の `wsl-arch` を対象にしています。

## Layout

- `flake.nix`: entrypoint
- `hosts/`: host ごとの差分
- `home/`: Home Manager の user-level 設定
- `darwin/`: nix-darwin の system-level 設定
- `files/`: raw dotfiles
- `legacy/`: Nix 化対象外の旧設定

## Install Nix

- macOS: [nix-darwin README](https://github.com/nix-darwin/nix-darwin)
- WSL / Linux: [Home Manager manual](https://nix-community.github.io/home-manager/)

## One Shot Bootstrap

この repo では `scripts/bootstrap.sh` が Nix/Lix の導入、`flake.lock` 生成、`nix flake check`、設定反映までをまとめて実行します。

```sh
./scripts/bootstrap.sh
```

対象は `6uclz1` ユーザー上の `MacBook-Air-M4` と WSL 上の `wsl-arch` だけです。対象外の host では失敗させます。
ローカルの未 commit / 未 stage 変更を含めて評価するため、script 内部では絶対 `path:` 参照を使います。

## Bootstrap macOS

初回は `darwin-rebuild` がまだ PATH に無いので、flake input 経由で起動します。

```sh
sudo nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake "path:$PWD#MacBook-Air-M4"
```

導入後の反映は次です。

```sh
sudo darwin-rebuild switch --flake "path:$PWD#MacBook-Air-M4"
```

## Bootstrap WSL

Home Manager standalone を使います。`home-manager` コマンド未導入でも `nix run` で反映できます。

```sh
nix run github:nix-community/home-manager/release-25.11 -- switch --flake "path:$PWD#6uclz1@wsl-arch"
```

導入後は次でも反映できます。

```sh
home-manager switch --flake "path:$PWD#6uclz1@wsl-arch"
```

## Update

```sh
nix flake update --flake "path:$PWD"
nix flake check --flake "path:$PWD"
```

その後、対象 host に対して `darwin-rebuild switch` または `home-manager switch` を実行します。

## Rollback

- macOS: `darwin-rebuild --list-generations`
- WSL: `home-manager generations`

世代を確認して必要な generation に戻します。

## Migration Notes

- Zsh plugin と prompt は Nix package ベースで構成します。`~/.zsh` への手動 clone は不要です。
- Vim は `files/vimrc` を Home Manager から `~/.vimrc` に配置します。
- Windows native は `legacy/windows/install.ps1` に切り離し、Phase 1 では管理しません。
