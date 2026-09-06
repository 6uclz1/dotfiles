# Mac初期セットアップ

Apple SiliconのMacを、Homebrew＋シェルスクリプトでセットアップします。
この `macOS` ブランチは普段使い用です。`master` のMac mini用Nix構成とは別に管理します。
初版の検証対象はmacOS 26です。管理者ユーザーでmacOSの初期設定を済ませ、ターミナルで実行してください。

## 初回：1コマンドで開始

**以下はこの変更が `macOS` ブランチへマージされた後に利用できます。**

```sh
/bin/bash -c 'dotfiles_bootstrap=$(curl -fsSL https://raw.githubusercontent.com/6uclz1/dotfiles/macOS/bootstrap.sh) && /bin/bash -c "$dotfiles_bootstrap"'
```

取得に失敗した場合は実行しません。実行内容を先に確認する場合は
[bootstrap.sh](bootstrap.sh) を読み、保存したファイルを `bash bootstrap.sh --dry-run` で確認できます。

順序は、Command Line Tools → Homebrew → git・ghq → リポジトリ取得 → CLI・Zsh・macOS設定 → 検証です。
Command Line Toolsの確認画面と、Homebrew公式インストーラーの管理者パスワード・確認操作は手動です。
CLTは最大30分待機します。中断・失敗したら原因を解消して同じコマンドを再実行できます。
`sudo bash setup.sh` のような全体のroot実行は拒否します。

## リポジトリはghqで管理

既定の保存先は `~/ghq/github.com/6uclz1/dotfiles` です。
`ghq.root` や `GHQ_ROOT` を設定済みなら、その設定を利用します。Git設定は書き換えません。

```sh
ghq list --full-path --exact github.com/6uclz1/dotfiles
cd "$(ghq list --full-path --exact github.com/6uclz1/dotfiles)"
./setup.sh --check
```

初回取得では `ghq get --no-recursive --branch macOS` を使います。
すでにあるcheckoutはorigin・ブランチ・未コミット変更を検証し、そのまま使います。
別リポジトリ、別ブランチ、detached HEAD、未コミット変更、Git管理外の同名ディレクトリでは停止します。
複数のghq rootに同じリポジトリがある場合は `GHQ_ROOT` で一つを指定してください。
`~/dotfiles` などghq外の既存コピーは自動移動しません。

更新は、変更内容を確認してから手動で行います。bootstrapは自動pullしません。

```sh
cd "$(ghq list --full-path --exact github.com/6uclz1/dotfiles)"
git pull --ff-only origin macOS
./setup.sh --dry-run
./setup.sh
```

## 導入・設定するもの

Brewfileの対象：`git`、`gh`、`ghq`、`ripgrep`、`fd`、`fzf`、`jq`、`shellcheck`。
GUIアプリ、言語ランタイム、Nix、サービスは導入しません。
通常は `brew bundle install --no-upgrade` で不足分を追加し、一括更新・cleanup・削除を行いません。
不足パッケージの導入に必要な依存関係はHomebrewが解決するため、依存の更新が発生する場合があります。
バージョンの完全固定・過去バージョンの再現は対象外です。

[config/macos.tsv](config/macos.tsv) の値を編集すると、次回以降も同じ設定を再現できます。
タブ区切りの4列（domain / key / type / value）です。空行・`#`コメントを利用できます。
キーの追加は検証用allowlistも変更する必要があります。初版では次の値を管理します。

| 項目 | 値 |
|---|---|
| キーリピート | `KeyRepeat = 2`（int） |
| リピート開始待ち | `InitialKeyRepeat = 15`（int） |
| マウス速度 | `com.apple.mouse.scaling = 3`（float） |
| トラックパッド速度 | `com.apple.trackpad.scaling = 3`（float） |
| Finderの隠しファイル | 表示 |
| 拡張子 | 表示 |
| Finderのパスバー・ステータスバー | 表示 |
| ユーザーLibrary | 表示 |

速度値は「速め」の初期候補です。保存値の一致と体感は別に確認してください。
macOSや周辺機器のドライバーによって反映が異なる場合があります。
スクロール方向、キー配列、自動修正、Dock、電源、SSH・DNSは変更しません。

## Zsh

管理対象は `~/.zprofile` と `~/.zshrc` の識別コメントに囲まれたブロックだけです。
既存内容を残してHomebrew環境と最小限の補完・履歴設定を読み込みます。
リポジトリ内の `shell/` を絶対パスで参照するので、checkoutは削除しないでください。
移動した場合は新しい場所で `./setup.sh --only shell` を再実行します。

- `ghq get owner/repo`：リポジトリを取得
- `ghq list`：管理中のリポジトリ一覧
- `cghq`：fzfで選択して移動。キャンセル時は移動しない

Zshファイルがsymlink、管理ブロックが破損、または環境変数 `ZDOTDIR` がHOME以外なら停止します。
`.zshenv` 等で独自の `ZDOTDIR` を設定している場合も、既存構成への統合を先に行ってください。
旧 `.zshrc`、Vim、tmux等は参考資料として残しますが自動配置しません。
旧 `system.sh` / `makelinks.sh` は新しいmacOS設定 / Zsh設定だけを実行する入口です。

## 操作

```sh
./setup.sh                         # 全体
./setup.sh --only brew             # Homebrew・CLIのみ
./setup.sh --only shell            # Zshのみ
./setup.sh --only macos            # macOS設定のみ
./setup.sh --dry-run               # 変更予定だけ表示
./setup.sh --only macos --dry-run
./setup.sh --check                 # 読み取りによる検証
./setup.sh --only shell --check
./setup.sh --restore 20260906-120000.ABC123  # 実際に表示されたIDを指定
```

`--dry-run` はインストール・書き込み・ネットワーク接続を行いません。
`--check` は不足・不一致があれば非ゼロ終了します。brewの確認時も自動更新を抑止します。
失敗時はエラーとバックアップ先を表示し、成功として扱いません。
同じ値・同じブロックは変更せず、同時のsetup実行はロックで防ぎます。

## バックアップと復元

変更のある実行ごとに、次のリポジトリ外の場所へ権限700で保存します。
既存バックアップは上書きしません。変更がない実行では新しいバックアップを作りません。

```text
~/Library/Application Support/6uclz1-dotfiles/backups/<バックアップID>/
```

- macOS：変更したキーの元の型と値、未設定だった状態を保存。未設定への復元はキー削除。
- Library：hiddenフラグだけを保存・復元。
- Zsh：元のファイル・存在の有無・適用予定の内容を保存。

Zshファイルをセットアップ後に編集した場合、復元はその編集を消さず停止します。
バックアップ内の `.zshrc.before` / `.zshrc.after` 等と現状を比較し、手動で統合してください。
macOS設定の復元は指定IDの保存値を優先します。複数実行を戻す場合は新しいIDから順に戻します。
復元ではHomebrew・CLIのアンインストール、リポジトリ削除、履歴の削除はしません。

強制終了等でlockが残った場合は、他のsetupが動いていないことを確認してから
`rmdir "$HOME/Library/Application Support/6uclz1-dotfiles/lock"` を実行してください。
パスワード、トークン、SSH秘密鍵、バックアップ、個人用設定をコミットしないでください。

## 適用後に手動で確認すること

1. 新しいターミナルで `brew --version`、`ghq root`、`cghq` を確認。
2. 再ログインしてFinderの隠しファイル・拡張子・バー・Library表示を確認。
3. テキスト入力でリピート速度・開始待ちを確認し、マウスとトラックパッドを実際に操作。
4. 必要に応じて `gh auth login` を実行。アプリのログイン・OSの権限許可は手動。

スクリプトはFinder・ターミナルを強制終了せず、自動再起動・自動ログアウトも行いません。

## 開発・検証

```sh
bash tests/run.sh
```

Python 3はテスト専用で、セットアップ自体には不要です。
CIはLinuxとmacOS 26で、Bash構文・ShellCheck・Zsh構文・模擬外部コマンドのテストを実行します。
macOSでは一時plistへの実際の `defaults` と、一時Libraryの `chflags` による型・復元も検証します。
利用者の実設定やアプリのインストールには触れません。

PRブランチを初期状態の検証用Macで試す場合：

```sh
DOTFILES_BRANCH=codex/mac-setup /bin/bash -c 'dotfiles_bootstrap=$(curl -fsSL https://raw.githubusercontent.com/6uclz1/dotfiles/codex/mac-setup/bootstrap.sh) && /bin/bash -c "$dotfiles_bootstrap"'
```

既存コピーが別ブランチなら自動切替せず停止します。
初期状態のMacでのCLT画面・管理者認証・Homebrew実導入・操作感の確認は、模擬テストと区別して記録します。

参考：[Homebrew Installation](https://docs.brew.sh/Installation)、
[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)、
[ghq](https://github.com/x-motemen/ghq/blob/master/README.adoc)。
