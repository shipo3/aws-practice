## サーバー/アプリケーションを分けて動かす ##
1. Nginxをインストール
2. Nginxの権限を変更
3. Unicornのインストール
4. Nginxを再起動
```bash
sudo service nginx restart
```
5. Unicornを起動
```bash
bundle exec unicorn_rails -l 3000
```  
↓  
アプリが操作できる

＜エビデンス＞
![分けて動かす](images/unicorn.png)

### この作業から学んだこと ###
* 改めてLinuxコマンドが学び直せた
* viエディタの使い方　便利！と思えるようになった。
* listenポートを指定しないとアクセスできなかったのが少し不思議。。

