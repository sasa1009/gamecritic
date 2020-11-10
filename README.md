## アプリ概要  
gamecriticはゲームソフトのユーザーレビューサイトです。  

## URL
https://www.gamecritic.net  

## 機能紹介
- ユーザーレビュー機能  
ゲームソフトのユーザーレビューを閲覧したり投稿したりできます  
![ユーザーレビュー機能](https://user-images.githubusercontent.com/35237920/98596029-32014d00-231a-11eb-8596-95c7d54c9177.png)
- フレンド募集機能  
オンラインマルチプレイで共に遊ぶ仲間を募ることができます。  
![フレンド募集機能](https://user-images.githubusercontent.com/35237920/98596057-39c0f180-231a-11eb-8cea-ae1c8d73f79a.png)
- モーダル機能
ユーザーレビュー投稿に添付された画像をクリックするとモーダルで拡大表示されます。また長文のフレンド募集投稿はモーダルで表示することができます。  
![モーダル機能](https://user-images.githubusercontent.com/35237920/98596041-362d6a80-231a-11eb-81ba-b4b859dfddee.png)
- アコーディオン機能  
ユーザーレビュー等の文が長文の場合、初期状態では全て表示せずに「全てを表示」をクリックすることで全文を表示させることができます。

- プロフィール機能
ユーザー名、自己紹介文、アイコン画像の投稿ができます。
![プロフィール投稿機能](https://user-images.githubusercontent.com/35237920/98596062-3c234b80-231a-11eb-90cc-4c4ffa6d1be8.png)
- 投稿管理機能
ユーザープロフィールページにユーザーが投稿したレビュー・フレンド募集投稿が一覧表示されます。

- ゲームソフト投稿機能
サイト管理者はゲームソフトのデータを投稿することができます

使用技術一覧
### バックエンド
  Ruby 2.6.5  
  Rails 5.2.4  
  DB: PostgreSQL  

### フロントエンド
  JavaScript  
  jQuery  
  SCSS  
  Bootstrap4

### テスト
  RSpec

### 開発環境
  Docker  
  Docker Compose

### ソースコード管理
  Git  
  GitHub

### インフラ
  AWS(VPC, EC2, RDS, Route53, S3)

### ネットワーク構成図  
![ネットワーク構成図](https://user-images.githubusercontent.com/35237920/98587079-04fa6d80-230d-11eb-8021-bb0b92f24f67.jpg)

### ER図
![ER図](https://user-images.githubusercontent.com/35237920/98587060-fd3ac900-230c-11eb-9955-43babaf2cfd6.jpg)
