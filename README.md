# isucon-toolbox

isucon用のツール群まとめ

## 初回ログイン後にやること

### isuconユーザーでログインできるようにする

```bash
# isuconユーザーで.sshディレクトリを作成
sudo su - isucon
mkdir -p .ssh

# ssh keyのisuconユーザへの登録
sudo cp /home/ubuntu/.ssh/authorized_keys  /home/isucon/.ssh/authorized_keys
sudo chown isucon:isucon /home/isucon/.ssh/authorized_keys

# public ipの確認
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

ローカルの`~/.ssh/config`に以下を追加

```ssh
Host isucon-2023-X
  HostName <public ip>
  User isucon
  IdentityFile ~/.ssh/isucon.pem
```

### デフォルトの状態でベンチを動かす

当日のマニュアルに従って、ベンチを動かしておく。

**🚨 実行結果を揃える意味でも、ベンチの実行コマンドを作業用docの先頭に書いておく!!**

### 1台目のサーバーに接続して、初期化を行う

path/to/webapp/go なディレクトリ構成な前提。

VS CodeのRemote SSHで接続して、go ディレクトリ内のMakefileに本repoのMakefileをコピーする

**🚨 Makefile内のSERVICE_NAMEを実際の値に書き換える!!**

```bash
# git の初期設定
export GIT_HUB_USER_EMAIL=<your email>
export GIT_HUB_USER_NAME=<your name>
config.git
# gh cli をインストール ref: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
gh auth login
ssh -T git@github.com

# 念のためバックアップ
cp -prf path/to/webapp path/to/webapp_bak

cd path/to/go
make init.config init.asdf
# ASDF_DIRSがなんたらエラーで落ちたら
. ~/.bashrc
make init.tools log.init
```

その後

- `make restart` でサーバーを再起動する

- `make survey` でベンチの結果が取れることを確認する

が確認できてら、git initして、リモートリポジトリにpushする。

```bash
git init
vi README.md
git add .
git commit
git branch -M main
git remote add origin git@github.com:...
git push -u origin main
```

## 2台目以降のサーバーに接続して、初期化を行う

1台目からpushしたリポジトリをcloneする。

**🚨 cloneすると.gitconfigで指定されたファイルが消えてしまい初期化などに失敗する可能性があるので、バックアップからよしなに復元すること!**

```bash
cd path/to/webapp
cd ..
mv webapp webapp_bak
git clone <private_repo>
mv <private_repo> webapp
```

あとは同じ

- `make restart` でサーバーを再起動する
- `make survey` でベンチの結果が取れることを確認する

## 便利コマンド集

どんどん追加しよう

```bash
# PR作成
gh pr create --fill

```
