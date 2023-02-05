## 見積り作成 ##
### AWS Pricing Calculator　の使い方 ###
1. 見積りツールへアクセス　[https://calculator.aws/#/](https://calculator.aws/#/)
2. 見積りしたいサービス（EC2とか）を選び「設定」ボタンをクリック  
---以下　EC2を選択した場合---
3. リージョンと見積の種類を選ぶ
4. OSを選択する
5. Workloadタイプとして4つの中から選ぶ  
   - 一定の使用量
   - 毎日のスパイクトラフィック
   - 毎週のスパイクトラフィック
   - 毎月のスパイクトラフィック
6. インスタンス数を選ぶ　
7. インスタンスタイプを選ぶ  
　＊Instance family、vCPU, メモリ, Network performanceで絞り込める
8. 支払い方法「価格モデル・予約期間・支払いオプション」を選択する

　＜価格モデル＞  
**Compute Savings Plans**  
  最も優れた柔軟性を提供し、コストを最大 66% 削減する  
  ＊EC2 インスタンスの使用に自動で適用されます。  
  ＊また、Fargate や Lambda を使用する場合にも適用されます。  

**EC2 Instance Savings Plans**  
 料金が最も低く、リージョン内の個々のインスタンスファミリーの契約と引き換えに 
 最大 72% の節約を提供します。

　＜予約期間＞  
　  1年　or 　3年  
 ＜支払いオプション＞  
　  前払い / 一部前払い / 全額前払い

9. インスタンスにアタッチされているストレージの見積りや、インスタンスのスナップショットの見積りを追加する
10. 毎月のデータのアップロード/ダウンロード量を推定できる場合は、これらのコストを見積りに追加する
11. 「サービスを保存して追加」押下する

### 見積りした構成 ###
---EC2---
- リージョン：アジアパシフィック（東京）
- OS：Linux
- Workloadタイプ：一定の使用量
- インスタンス数：1
- インスタンスタイプ：t2.micro
- お支払い：EC2 Instance Savings Plans
- EBS：汎用SSD 20GB

---RDS---
- リージョン：アジアパシフィック（東京）
- MySQL インスタンス：db.t3.micro
- 数量：１
- デプロイオプション：Single-AZ
- 価格モデル：OnDemand
- RDSプロキシ：いいえ
- ストレージ：汎用SSD 20GB

---ELB---
- リージョン：アジアパシフィック（東京）
-  ELB関数のオプション：Application Load Balancer
- Application Load Balancer：AWS リージョンのロードバランサー
- 数量：１
- ALB ごとの新しい接続の平均数：1/1秒

### 見積り共有URL ###
[My Estimate](https://calculator.aws/#/estimate?id=5690b56557804a60edba0fb324b8c7a94ea2e82c
)

