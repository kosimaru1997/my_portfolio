サイトURL：　https://xn--n9jfc1f0c1grbyi7gxp.com/ (エンジニアになるまで.com)  

# エンジニアになるまで
<div>
  <img src="https://user-images.githubusercontent.com/79825084/128097357-b31f0997-941f-4a3c-92d8-107edb12f588.png" width="90%">　　
</div>
<div style="margin-bottom 10px;">
  <img src="https://user-images.githubusercontent.com/79825084/125649390-99e6bb12-6e19-4147-aba2-c10171b7905c.png" width="20%">　
  <img src="https://user-images.githubusercontent.com/79825084/125648586-6251dd96-a222-4d6f-b704-9eb1399b44d7.png" width="20%">　
  <img src="https://user-images.githubusercontent.com/79825084/125650029-d7ca33ef-08cf-4c07-98a6-b9d1076e6d60.png" width="20%">　　
  <img src="https://user-images.githubusercontent.com/79825084/125827778-46055e91-268a-4bba-8755-b91b6a1a079c.png" width="23%">　
</div>

<div>
  <img src="https://user-images.githubusercontent.com/79825084/130475443-5404f28d-fd1c-47c4-8ddb-3571bd4f2976.png" width="90%">　  
  
  New Release!  
  スクレイピングによりURLから外部サイトの情報を取得し保存する機能を追加しました。(より使いやすくするために開発中です。）
</div>

## サイト概要
エンジニア初学者が情報を共有するためのアプリです。
ユーザーの投稿一覧を閲覧したり、コメントを残すことができます。  
また、自身の悩みや、学習過程を呟いたり、  
学習で利用したサイトを登録することができます。  

### サイトテーマ
「エンジニアになるまで」  
エンジニア初学者のためのコミュニティサイトです。プログラミング初心者の情報共有をテーマにしています。

### テーマを選んだ理由
未経験エンジニアとして、プログラミングスクールに在籍していますが、  
スクールに在籍することで、未経験ながらエンジニアを目指している仲間達の存在を実感でき、  
学習を進める上で大変励みになりました。  
  
１つのスクールだけではなく、オンライン上で様々な未経験エンジニアの方々と繋がれるコミュニティが欲しいと思い、  
今回のアプリ開発に至りました。

### ターゲットユーザ
・エンジニア初学者の方々

### 主な利用シーン

・自分以外のエンジニア初学者の情報を知りたい時  
・エンジニア初学者としての近況を発信したい時  

## ER図

![スクリーンショット 2021-06-30 3 13 03](https://user-images.githubusercontent.com/79825084/123847267-5c5b5580-d951-11eb-8bad-fed787b749f1.png)
<!-- https://app.diagrams.net/#G19MSTgCaf3ddilD5w0r2Ofhu3RYUa9_LC   -->
<!-- テーブル定義書  
https://docs.google.com/spreadsheets/d/1d5gmjA4eFFvZiRHlB6r5tNswYaAGzvUiuPYxAmBsEDs/edit#gid=1427335530  
詳細設計書  
https://docs.google.com/spreadsheets/d/1Qb4WOSmpRb9nLdiNKu54Ly3G1wDO0JN3PgWfEfZb4H4/edit#gid=0 -->

## 機能・実装一覧
・ポストの投稿、ポストへのコメント、コメントへの返信（リプライ）機能  
・Webサイトの登録機能（スクレイピングにより外部サイトのOGP画像、タイトルを取得）  
・リポスト（リツイート）機能  
・RSpec(System Spec)を用いたE2Eテスト  
・お問い合わせ機能（Actionmailerを使用）  
・N+1問題への対応（gem'bullet'、gem'counter_culture'を使用）  
・非同期通信  
・通知機能(2種類)  
　　1　フォローされた時、投稿に対してコメント、リプライを受けた時  
　　2　DMを受けた時  
・リンクプレビュー機能（外部API　'link_preview'を使用）  
・GitHub Actionsを用いた自動でデプロイ  

＊その他、機能・実装の詳細は下記URLをご確認願います  
https://docs.google.com/spreadsheets/d/1_HPNzhP4DSkcBaBIqMjc8MeEn3_E1-fHyP7tUgCb5Tc/edit#gid=0

## 使用技術

- バックエンド言語：Ruby 2.6.3
- テストフレームワーク：Rspec
- フレームワーク：Ruby on Rails 5.2.6  
- データベース ：MySql 5.7  
- フロント言語：JavaScript
- JSフレームワーク：jQuery
- IDE：Cloud9  

## 本番環境

- AWS (EC2、RDS、Route53)
- Nginx、 Puma
- Github actionを用いた自動デプロイ 

<!--## 使用素材-->
<!--- 外部サービスの画像素材・音声素材を使用した場合は、必ずサービス名とURLを明記してください。-->
<!--- 使用しない場合は、使用素材の項目をREADMEから削除してください。-->
