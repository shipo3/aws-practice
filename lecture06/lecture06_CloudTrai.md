# 第6回課題 #
## CloudTrail ##
### CloudTrail のイベント確認方法 ###
1. CloudTrailコンソールを開く
2. 左カラムにて「イベント履歴」を選択する
3. 任意のイベントをクリックする
4. 選択した任意のイベントの詳細情報が展開されるので、左下の [イベントの表示] をクリックする
5. モーダルウィンドウが開き、JSON形式の証跡ログが表示される

### 確認するポイント ###
- userIdentityのaccountIdやuserName
    - どのAWSアカウントのどのユーザが行った作業か確認できる
- eventTime
    - UTCで保存されている
- eventSource
    - 利用したサービス
- eventName
    - 対象サービスで行った操作
- sourceIPAddress
    - リクエストを行ったIPアドレスが表示される
- **requestParameters**：AWS APIのリクエスト
- **responseElements**：AWS APIのレスポンス  
- 詳細や他の項目については「[こちら](https://docs.aws.amazon.com/ja_jp/awscloudtrail/latest/userguide/cloudtrail-event-reference-record-contents.html)」

### 確認結果 ###
```bash
##　EC2の操作履歴
"userName": ログイン時のIAMユーザー,
"eventTime":  "2023-01-29T13:08:34Z",
"eventSource": "ec2.amazonaws.com",
"eventName":  "StopInstances",
"awsRegion":"ap-northeast-1",
"sourceIPAddress": My IP,

##　S3の操作履歴
"userName": ログイン時のIAMユーザー,
"eventTime": "2023-01-29T08:10:39Z",
"eventSource": "s3.amazonaws.com",
"eventName": "ListAccessPoints",
"awsRegion": "ap-northeast-1",
"sourceIPAddress": My IP,

##　ALBの操作履歴
"userName": ログイン時のIAMユーザー,
"eventTime": "2023-01-29T13:08:18Z",
"eventSource": "elasticloadbalancing.amazonaws.com",
"eventName": "DescribeLoadBalancers",
"awsRegion": "ap-northeast-1",
"sourceIPAddress": My IP,

```

### CloudTrail 他にできること ###
* 90日以上保存したい場合は、「証跡」を作成してS3へ保存できる
　※S3への保存料金は発生します。
* Athenaを使ってクエリをかけることも可能
* ログの記録のON/OFFは、[CloudTrai]l >[ 証跡情報] > （各証跡の）設定 から行える
* CloudTrail からログを受信するよう CloudWatch Logs を設定することで、特定のログイベントをモニタリングすることも可能

