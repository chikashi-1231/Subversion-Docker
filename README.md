# SVN Docker
下記の要件を満たすSubversionのDockerコンテナ
- `svn://`のみでなく`http://`のプロトコルでもアクセスしたい
- LDAP認証により、認証統合を実現したい

## 使い方
1. Dockerビルドを行う
    ```bash
    $ docker build -t subversion:latest .
    ```
2. docker-composeを使ってコンテナを立ち上げる
    ```bash
    $ docker-compose up -d
    ```
3. レポジトリの作成
    ```bash
    $ docker exec -it subversion bash
    ...
    subversion$ cd /home/svn/repos
    subversion$ svnadmin create testrepo
    ...
    subversion$ ls testrepo
    README.txt  conf  db  format  hooks  locks
    ```
4. レポジトリへのアクセス
    `localuser.list`に記載されている初期ユーザーは下記になる。これで一旦はアクセスが可能であるが、適宜変更してほしい。
    - ID : admin
    - PW : admin

## LDAPの設定
- 下記のファイルを編集する事でLDAPの設定を行う<br>
    `/usr/local/apache2/conf/extra/svn.conf`
- `docker-compose.yaml`の中身を見ていただくと分かる通り、このファイルはホストOSにマウントされているのでホストOS側から直接編集してもよい