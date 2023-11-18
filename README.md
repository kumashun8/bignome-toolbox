# isucon-toolbox

isucon用のツール群まとめ

## 初回ログイン後にやること

### isuconユーザーでログインできるようにする

```bash
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

### 1台目のサーバーに接続して、初期化を行う

path/to/webapp/go なディレクトリ構成な前提。

VS CodeのRemote SSHで接続して、go ディレクトリ内のMakefileに本repoのMakefileをコピーする

```bash
export GIT_HUB_USER_EMAIL=<your email>
export GIT_HUB_USER_NAME=<your name>

# 念のためバックアップ
cp rf path/to/webapp path/to/webapp_bak

cd path/to/go
make init.git
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

**cloneすると.gitconfigで指定されたファイルが消えてしまい初期化などに失敗する可能性があるので、バックアップからよしなに復元すること!**

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
