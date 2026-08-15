# Mac mini dotfiles

現在の Mac mini の稼働構成を再現するための nix-darwin flake です。
Determinate Nix、CLI ツール、Homebrew、SSH、AdGuard Home、macOS Firewall、
サーバー向け電源設定を管理します。

## 対象

- Apple Silicon Mac mini (`aarch64-darwin`)
- Homebrew 実行ユーザー: 既存の `alice` アカウント
- Nix: Determinate Nix
- nix-darwin `system.stateVersion`: `6`

macOS の ComputerName、HostName、LocalHostName とユーザーアカウントは
Nix の管理対象外です。`homebrew.user = "alice"` は Homebrew を実行する既存
アカウントの指定であり、そのアカウント自体は作成・変更しません。

## 管理しているもの

- Determinate Nix と macOS build sandbox
- `age`、`bat`、`bottom`、`fd`、`gh`、`git`、`jq`、`just`、
  `restic`、`ripgrep`、`shellcheck`、`sops`、`tmux`、`tree`、`watch`
- Homebrew の `smartmontools` と Ghostty
- 公開鍵認証のみの SSH（Tailscale のアドレス範囲からだけ接続可能。鍵は管理外）
- AdGuard Home 0.107.78（Apple Silicon 版を SHA-256 で固定）
- macOS Application Firewall、stealth mode、Wake-on-LAN
- スリープ無効、停電復帰後の自動起動

## 新しい Mac mini への復元

### 1. macOS の準備

macOS の初期設定を完了し、既存ユーザー名が `alice` でない場合は
`configuration.nix` の `homebrew.user` をその名前へ変更します。

```sh
xcode-select --install
```

Homebrew をインストールします。nix-darwin は既存の Homebrew を利用します。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Determinate Nix とリポジトリ

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/6uclz1/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. 評価、ビルド、適用

最初に flake を検証し、システムをビルドします。

```sh
nix flake check
nix build .#darwinConfigurations.mac-mini.system
```

初回は、ビルドされた `darwin-rebuild` を使います。

```sh
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac-mini
```

2 回目以降:

```sh
sudo /run/current-system/sw/bin/darwin-rebuild switch \
  --flake ~/dotfiles#mac-mini
```

## Tailscale と AdGuard Home

Tailscale は Nix ではなく、公式の standalone macOS package で管理します。
公式 package をインストールして tailnet に接続し、このホストへ安定した
Tailscale IP `100.120.189.89` を割り当ててから flake を適用してください。

AdGuard Home は root の launch daemon として起動し、設定と作業データを
`/var/lib/AdGuardHome` に保存します。初回は Tailscale 経由で次を開きます。

```text
http://100.120.189.89:3000
```

セットアップ値:

- Admin web interface: `100.120.189.89:3000`
- DNS server: `100.120.189.89:53`
- Upstream: Quad9 DNS-over-HTTPS
- DNSSEC: enabled
- Default AdGuard DNS blocklist: enabled、毎日更新
- Query log / statistics retention: 24 hours
- Browsing security / parental control / SafeSearch: disabled

セットアップ完了後、クライアントから DNS 解決とブロックを確認してから、
Tailscale の global nameserver に `100.120.189.89` を設定し、
**Override DNS servers** を有効にします。MagicDNS は有効のままにします。

## 秘密情報

パスワード、秘密 SSH 鍵、API token、age identity、AdGuard Home の実データは
コミットしません。SSH 公開鍵は既存ユーザーの `~/.ssh/authorized_keys` に
手動で配置します。AdGuard Home の管理者パスワードは password manager に保存し、
新しいホストで再設定してください。

FileVault と Time Machine はこの flake の管理外です。age/sops の永続 identity
を追加する場合は、先に FileVault と復旧可能なバックアップを準備してください。

## 運用

更新前に必ず評価とビルドを行います。

```sh
cd ~/dotfiles
nix flake check
nix build .#darwinConfigurations.mac-mini.system
sudo darwin-rebuild switch --flake .#mac-mini
```

input の更新は独立した変更として行い、更新後の `flake.lock` をコミットします。

```sh
nix flake update
nix flake check
nix build .#darwinConfigurations.mac-mini.system
```

ロールバック:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild switch --rollback
```

## 適用後の確認

```sh
launchctl print system/org.nixos.adguardhome
pmset -g custom
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode
ssh -o PasswordAuthentication=no your-user@your-host
```
