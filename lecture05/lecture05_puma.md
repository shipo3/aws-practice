# 第5回課題 #
## 組み込みサーバーだけで動かす ##
1. パッケージをアップデート
2. Railsアプリを動かす為に必要なパッケージをインストール
3. JavaScriptを実行できるようNode.jsをインストール
```bash
# バージョン確認
$ node --version　　→　ver 14.21.1
```
4. Rails6以降はyarnを使うので、yarnもインストール
```bash
# バージョン確認
$ yarn --version　　→　ver 1.22.19
```
5. rubyのバージョン管理ツールrbenvをインストール  →　rbenvにパスを通す.bash_profileの設定
6. rubyをインストールするためのruby-buildをインストール
7. rubyをインストール
```bash
# バージョン確認
$ ruby -v    →　ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]
```
8. Railsインストール
```bash
# バージョン確認
$ rails -v
```
9. MySQLインストール
 - `$ sudo yum localinstall -y $MYSQL_PACKAGE_URL`が成功しない場合はwgetする
 - mysql2 gemのインストールで必要な「mysql-devel」もインストールする
 - インストール後、MySQLサーバーの起動＆確認を行う
10. サンプルAPPをclone
11. サンプルAPPのディレクトリに移動して、bundlerインストール
12. RDSに接続するために「config/database.yml」を修正
 - 今回のサンプルアプリではDB設定ファイルが「database.yml.sample」になっているので「database.yml」にファイル名を変更
 - MySQLパスワードが初期値のままだと進めなかったので、RDSと同じパスに変更
13. データベースを作成
```bash
$ rails db:create
$ rails db:migrate
```
14. scssの手動コンパイル実施
```bash
$ rails assets:precompile  →　「application.css」が作成される
```
15. アプリ実行
```bash
rails s -b 0.0.0.0  ＊bindオプションでリスニングするIPを指定できる
```
16. ブラウザにて「http://EC2のパブリックIPアドレス:3000/」 にアクセス  
     ↓  
アプリが操作できる

＜エビデンス＞
![組み込みサーバーを使って](images/rails.png)

### この作業から学んだこと ###
* MySQLが入らない時、wgetを使ってインストールする方法
* database.yml記載の意味
* pumaで起動することの意味　
　https://style.potepan.com/articles/34157.html#Ruby_on_RailsWeb



