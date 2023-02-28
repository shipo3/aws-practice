# 第12回課題 Circle CI #
## CircleCIを課題のレポジトリに組み込む ##
1. CircleCIにログインする　
2. 左ペインにて「Projects」を選択する
3. 課題提出用のリポジトリにて「Set Up Project」を押下する
4. “Select your config.yml file” モーダルで、**Fast** を選択し「Set Up Project」を押下する
5. CircleCI 設定ファイルエディターが開いたら、課題用のサンプルコンフィグに書き換える
6. 「Commit and Run」を押下する
7. 当該リポジトリに“circle-ci-setup” という名前の新規ブランチが自動作成され「.circleci/config.yml 」ファイルが作成される
8. ステータスが「Success(グリーンビルド)」になっていれば成功！

## Linterとは ##
- 記述しているソースコード（CFnテンプレート）が妥当かどうかチェックしてくれるツール
- CloudFormationのLinterは2つある
1.  cfn-python-lint・・pythonで書かれたCloudFormationテンプレートのLinter
2. cfn-lint・・jsで書かれたLinter  
＊同じ **`cfn-lint`** コマンドで動きますが、**全く別の物**
- エディターのプラグインを入れるとエディター上でチェック出来るようになる！  
[Windows環境のVSCodeでcfn-lintを使えるようにする手順](https://qiita.com/kmmz/items/415af7c9270302d600f5)  

### cfn-python-lintのインストール ###
pipを使ってインストール
```java
$ pip install cfn-lint
```
### cfn-python-lintの使い方 ###
CFnテンプレート名を引数に **`cfn-lint`** コマンドを実行すると、CFnテンプレートのおかしなところを出力してくれる
```java
$ cfn-lint テンプレート名.yml
```

## 遭遇したエラー ##
- 手順8のステータスが「Faild」になっている  
⇒ 「run cfn-lint」にてファイルが見つからないエラー  
  　`- ERROR - Template file not found: cloudformation/*.yml`

　以下までは成功  
   ＊Spin up environment (環境のスピンアップ)  
   ＊Preparing environment variables (環境変数の準備)  
   ＊Checkout code (コードのチェックアウト)  
   ＊pip install cfn-lint（cfn-lintのインストール）  
⇒　フォルダ名をレポジトリに合せて「lecture10/*.yml」に変更してコマンド実行された

- lintが機能し、色々エラーが出る。。  
パラメーター使われてない。。  
`Parameter XXXX not used.`  
ハードコードにしないで。。  
`Don't hardcode XXXX`  
既に依存関係が強制されているから。。  
`Obsolete DependsOn on resource (InternetGateway), dependency already enforced by XXX`

⇒　cloudformationのファイルを修正⇒　エラーが1つになる

- 「Parameter DBMasterUserPassword used as MasterUserPassword, therefore NoEcho should be True」エラー  
⇒　パラメーターの「DBMasterUserPassword」を「MasterUserPassword」に変更したが同じ  
⇒　パラメーター「MasterUserPassword」に「NoEcho: 'true’」を追加して解消！

## エビデンス ##
*実行結果*  
![実行結果](../images/CircleCIーresult.png)  

## 感想 ##
- ずっと気になってたCircleCIが体験出来ました!
- 初見でも直感的に操作できてなかなか分かりやすいツールだと思いました。
- lintツールが便利であることを実感しました。
- Github Actionsとはワークフローの設定方法が異なることが分かりました。