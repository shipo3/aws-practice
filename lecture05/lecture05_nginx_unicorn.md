## サーバー/アプリケーションを分けて動かす ##
1. Unicornのインストール
- GemファイルにUnicornの記載があるか確認→　なければ追記する
- Sampleアプリにはすでに記載あった為、今回は必要なかった。
-  `bundle install`でUnicornをインストール  
→　Sampleアプリでは組み込みサーバーで実施した時にインストールされていた。
- バージョン確認　`unicorn -v`　→　unicorn v6.1.0
2. アプリのconfigディレクトリに「unicorn.rb」ファイルを作成し、Unicornの設定をする  
→　Sampleアプリにはすでに記載あった為、必要なかった。
3. Unicornのみを起動させて8080にてアクセス確認する
- unicorn.rbのリスンポートを「listen 8080」に変更　`vim config/unicorn.rb`
```bash
# listen '/home/ec2-user/raisetech-live8-sample-app/unicorn.sock'
# pid    '/home/ec2-user/raisetech-live8-sample-app/unicorn.pid'
listen 8080
```
- `$ bundle exec unicorn_rails`にて起動
- ブラウザにて「http://EC2のパブリックIPアドレス:8080/」 にアクセスする  
→　アプリが見られることを確認
4. Nginxをインストール
```bash
＊Amazon Linux 2の場合
＊amazon-linux-extrasを使ってインストールできるパッケージが確認できる
$ sudo amazon-linux-extras install nginx1

バージョン確認
$ nginx -v　　→　version: nginx/1.22.0
```
5. Nginxの権限を変更
```bash
$ cd /var/lib
$ sudo chmod -R 775 nginx
```
6. Unicornの設定をNginxを使用する用に戻す
```bash
listen '/home/ec2-user/raisetech-live8-sample-app/unicorn.sock'
pid    '/home/ec2-user/raisetech-live8-sample-app/unicorn.pid'
# listen 8080
```
7. Unicornの設定に合わせて、Nginxの設定ファイルを変更する
- `/etc/nginx/conf.d`に設定ファイル「rails.conf」を新規追加
- または`/etc/nginx`にある設定ファイル「nginx.conf」を修正
```bash
upstream unicorn_server {
  # Unicornと連携させるための設定。
  # config/unicorn.rb内のunicorn.sockを指定する
  server unix:/home/ec2-user/raisetech-live8-sample-app/unicorn.sock;
}

server {
  listen 80;
  # 接続を受け付けるリクエストURL ここに書いていないURLではアクセスできない
  server_name EC2のパブリックIPアドレス;

  client_max_body_size 2g;

  # 接続が来た際のrootディレクトリ
  root /home/ec2-user/raisetech-live8-sample-app/public;

  # assetsファイル(CSSやJavaScriptのファイルなど)にアクセスが来た際に適用される設定
  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @unicorn;

  location @unicorn {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://unicorn_server;
  }

  error_page 500 502 503 504 /500.html;
}
```
8. Nginxのworkerプロセス起動ユーザーをsockファイルへのアクセス権があるユーザーへ変更する
```bash
# nginxのworkerを動作させているユーザーの確認
$ ps aux | grep nginx
root      3879  0.0  0.2 121484  2216 ?        Ss   16:01   0:00 nginx: master process /usr/sbin/nginx
nginx     3881  0.0  0.4 121968  4904 ?        S    16:01   0:00 nginx: worker process ←これがworkerプロセス。nginxユーザーが動作させていることがわかる
ec2-user  3914  0.0  0.0 119436   920 pts/0    S+   16:08   0:00 grep --color=auto nginx

# unicornについては、ec2-userで起動させているので
nginxのプロセスを実行するユーザーをec2-userへ変更する。
$ sudoedit nginx.conf

#user nginx; ←コメントアウトして、
user ec2-user;　←追記
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
```
9. Nginxを起動させる
```bash
起動
$ sudo systemctl start nginx
状況確認
$ sudo systemctl status nginx
```
10. Unicornを起動させる
```bash
起動
$ bundle exec unicorn_rails -c config/unicorn.rb -D
起動確認
$ ps -ef | grep unicorn | grep -v grep
→　master、worker[0]など出てきたら起動している
```
11. ブラウザにて「http://EC2のパブリックIPアドレス」 にアクセスする

＜エビデンス＞
![分けて動かす](images/unicorn.png)

### この作業から学んだこと ###
* 改めてLinuxコマンドが学び直せた
* viエディタの使い方　便利！と思えるようになった。
* Unucorn、Nginxの起動・確認・停止方法
* Unucorn、Nginxの設定ファイルの書き方
* ログの場所
 - Unucorn `/home/ec2-user/raisetech-live8-sample-app/log/unicorn.log`
 - Nginx `/var/log/nginx/access.log`  `/var/log/nginx/error.log`

### 遭遇したエラー ###
1. vi で作成して記述したファイルが保存できない  
→　`vi`でなく`sudoedit ファイル名`で編集する（管理者権限で編集する）ことで保存できた

2. Nginx起動後、Unicorn起動コマンド打つが応答なし・・このサイトにアクセスできないエラー  
→　sudoedit  nginx.conf　にてserver部分をコメントにする  
→　nginxが起動できなくなる「Failed to start The nginx HTTP and reverse proxy server.」  
→　sudoedit  nginx.conf　にてserver部分をコメント解除→　Nginxが起動できた！  
→　ページ更新したら「502 bat gateway」
3. 502　Bad Gateway  
→　/var/log/nginx/sample_error.logの中身を確認してみる  
→　「13: Permission denied」などと表示されている場合は、nginxのプロセスを実行しているユーザーとunicornを実行しているユーザーが異なるため、unicorn.sockへのアクセス権限でファイルへのアクセスが拒否されている   
→　Nginxのworkerプロセス起動ユーザーをsockファイルへのアクセス権があるユーザーへ変更1して解消
4. Nginx＋Unicornで起動でき、アプリにアクセスできたが表示が崩れている（CSSが適用されてない)  
- [参考情報](https://www.sejuku.net/blog/100015)をやってみる
  → ディベロッパーツール内に「Console」にcssとjsの404エラー  
- jsとcss関係のファイル構成をCloud9を比較してみる  
  →　app/javascript/stylesheets  内に「application.js」がない。。他は同じ  
- webpacker入れてなかったので　`rails webpacker:install` してみる  
  →　rails --tasks にないから知らない。。と出る  
- Gemfileに「gem 'webpacker', '~> 3.0’」追記するか？  
  →　「webpackerは必要なし」の回答いただく  
  → アプリにあらかじめあった「package.json」には「webpack": "^5.74.0",」書いてある  
- CSSファイルが反映されない場合以下が足りない[記事](https://motomichi-works.hatenablog.com/entry/2020/08/09/002839)があったがすでに記載されていた

```
http {
  〜略〜
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  〜略〜
}
```
- 「/var/log/nginx/access.log」を確認する　`sudo tail /var/log/nginx/access.log`  
  → エラーはなし。。　アクセスしているIPアドレスも合っている
- 「/var/log/nginx/error.log」を確認する　`sudo tail /var/log/nginx/error.log`  
  →　assetsファイル「/home/ec2-user/raisetech-live8-sample-app/public/assets/application.debug・・・」が開けないエラーが表示されている  
- 追加した設定ファイル「rails.conf」に「root　 /home/ec2-user/raisetech-live8-sample-app/public;」追記してみるが同じ

```
[error] 3427#3427: *15 open() "/home/ec2-user/raisetech-live8-sample-app/public/assets/application.debug-40b03126ee30fb95eacf50ff9ae89564fae3eb9c9c55f9a4fad50e0d56ec8e83.js" failed (2: No such file or directory)
```
- 「nginx.conf」のserver部分をコメントアウトしてみる  
  →　状況変わらず。。アプリ開けて追加もできるがスタイルが適用されない
- 追加した設定ファイル「rails.conf」を削除して「nginx.conf」に今回のserver設定を追記したが同じ  
  →「nginx.conf」のassets 部分をコメントアウトしてスタイル適用された   
  →　コメントアウトを外しても表示OKになった！
5. `$ bundle exec unicorn_rails -c config/unicorn.rb -D`の後「master failed to start, check stderr log for details」となる  
 →　`/home/ec2-user/raisetech-live8-sample-app/log/unicorn.log`を確認すると「Please check your database configuration and ensure there is a valid connection to your database.」RDSが起動されていなかった