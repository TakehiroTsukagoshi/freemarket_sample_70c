# freemarket_sample_70c
* プログラミングスクールTECH::EXPERTの最終課題でフリーマーケットアプリを作成しました.
* 制作期間：約1ヶ月間
* メンバー5名でのアジャイル型開発（スクラム）

# リンク
* http://18.180.9.254 
* 上記のリンクよりログインが可能です。
* Basic認証を設定しておりますので下記IDとpassの入力をお願い致します。
* ID:admin
* pass:2222

# テストユーザー
* 購入者用アカウント
* メールアドレス: aaa@gmail.com
* パスワード: aaaaaaa

* 購入用カード情報
* 番号：4242424242424242
* 期限：01/25
* セキュリティコード：123

* 出品者用アカウント
* メールアドレス: bbb@gmail.com
* パスワード: aaaaaaa

# 使用技術一覧
* ruby 2.5.1
* rails 5.2.4.1
* JQuery 4.3.5
* MySQL 5.6.47
* Haml 5.1.2
* Sass 3.7.4
* Rspec 3.9.0
* AWS(EC2・S3)
* Github


# takehiro-tsukagoshi/担当箇所一覧
* スクラムマスター
* デプロイ作業全般
* DB設計全般
* 商品詳細画面(フロントエンド・サーバーサイド)
* 商品編集画面(フロントエンド・サーバーサイド)
* 商品削除機能
* コメント機能(投稿・削除)

# 担当箇所詳細
# ①スクラムマスター
* スクラムマスターとしてチームのタスクの振り分け・進捗管理・メンバーのフォローなどを行いました。

# ②デプロイ作業全般
* AWS(EC2・S3を使用)での本番環境へのデプロイ作業全般を担当しました。

# ③DB設計全般
* 本アプリケーションのDB設計を担当しました。
* ![freemarket_sample_70c_ER図](https://user-images.githubusercontent.com/59963342/77608611-17cc5780-6f61-11ea-9516-1676fec38e3c.png)

# ④商品詳細画面(フロントエンド・サーバーサイド)
* 出品されている商品の詳細画面の実装を担当しました。
* ![8b2cc7dcc0c7f0b3475661495b412d04](https://user-images.githubusercontent.com/59963342/77611090-c4113c80-6f67-11ea-9d08-18da5ccc5e3f.gif)

* JQueryを使用してカーソルと連動してプレビュー画像が動的に変化するように実装しました。
* ![4e8ad82892c705303f20452d1a371764](https://user-images.githubusercontent.com/59963342/77611471-c2944400-6f68-11ea-8b5e-246223534915.gif)
* <img width="556" alt="スクリーンショット 2020-03-26 13 46 33" src="https://user-images.githubusercontent.com/59963342/77611275-3eda5780-6f68-11ea-8d7c-cf4688bb65e1.png">

# ⑤商品編集画面(フロントエンド・サーバーサイド)
* 出品した商品の変種画面の実装を担当しました。
* 既に保存されている画像を削除ボタンを押すとajax通信を使用してDBから削除できる機能などを実装しました。
* ![0b1a17df272ebfd63cfd52c5af764b2e](https://user-images.githubusercontent.com/59963342/77611714-709fee00-6f69-11ea-9968-c60519a89e7c.gif)

# ⑥商品削除機能
* 出品されている商品の削除機能の実装を担当しました。
* ![81168422541bef86d9e0df35aba21153](https://user-images.githubusercontent.com/59963342/77611916-fb80e880-6f69-11ea-9098-b095d644889a.gif)


# ⑦コメント投稿機能
* 商品詳細ページにてその商品についてのコメントの投稿機能・削除機能を非同期通信で実装しました。
* ![9c289b59f2d2c6ed64285944f8ce0327](https://user-images.githubusercontent.com/59963342/77612211-e9ec1080-6f6a-11ea-95c1-5e39d1f4c13e.gif)


## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false|
|encrypted_password|string|null: false|

### Association
- has_one :profile
- has_one :creditcard
- has_many :products


## profilesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|references|foreign_key: true|
|lastname|string|null: false|
|lastname_kana|string|null: false|
|firstname|string|null: false|
|firstname_kana|string|null: false|
|birthday|date|null: false|
|postal_code|string|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|address|string|null: false|
|building|string||
|tel|string||


### Association
- belongs_to :user


## creditcardsテーブル
|Column|Type|Options|
|------|----|-------|
|card_id|integer|null: false, foreign_key: true|
|user_id|references|null: false, foreign_key: true|
|customer_id|integer|null: false, foreign_key: true|


### Association
- belongs_to :user


## productsテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false,foreign_key: true|
|brand|string|
|item_name|string|null: false|
|item_detail|text|null: false|
|item_size|string||
|condition_id|references|null: false,foreign_key: true|
|price|integer|null: false|
|category_id|references|null: false,foreign_key: true|
|delivery_pay_id|references|null: false,foreign_key: true|
|prefecture_id|references|null: false,foreign_key: true|
|lead_time|string|null: false|
|ststus|integer|null: false|



### Association
- belongs_to :user
- belongs_to :category
- has_many :images


## imagesテーブル
|Column|Type|Options|
|------|----|-------|
|image|string|null: false|
|product|references|null: false, foreign_key: true|


### Association
- belongs_to :product


## categorysテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|integer||


### Association
- has_many :products
