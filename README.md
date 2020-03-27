# freemarket_sample_70c
- プログラミングスクールTECHCAMPの最終課題でフリーマーケットアプリを作成しました.
- 制作期間：約3週間
- メンバー5名でのアジャイル型開発（スクラム）

# リンク
- http://18.180.9.254 
- 上記のリンクよりログインが可能です。
- Basic認証を設定しておりますので下記IDとpassの入力をお願い致します。
- ID:admin
- pass:2222

# テストユーザー
### 購入者用アカウント
- メールアドレス: aaa@gmail.com
- パスワード: aaaaaaa

### 購入用カード情報
- 番号：4242424242424242
- 期限：01/25
- セキュリティコード：123

### 出品者用アカウント
- メールアドレス: bbb@gmail.com
- パスワード: aaaaaaa

# 使用技術一覧
- ruby 2.5.1
- rails 5.2.4.1
- JQuery 4.3.5
- MySQL 5.6.47
- Haml 5.1.2
- Sass 3.7.4
- Rspec 3.9.0
- AWS(EC2・S3)
- Github


# takehiro-tsukagoshi/担当箇所一覧
- ユーザー新規登録/ログインページ(フロントエンド、バックエンド)
- 商品検索機能(フロントエンド、バックエンド)


# 担当箇所詳細
## ①ユーザー新規登録/ログインページ
### 概要
- 新規登録画面からユーザーの登録ができる
- ログイン画面からユーザーがログインできる
- トップページから新規登録画面/ログイン画面に遷移できる
- トップページからログアウトできる/マイページへ遷移できる
#### 担当内容(フロントエンド)
- haml,scssを使用し各画面のマークアップ作業
- ウィザード形式での新規登録
#### 担当内容(バックエンド)
- Ruby on Railsの”devise”というgemを使用し、ユーザー登録機能を実装
- deviseを編集しウィザード形式での新規登録を実装


## ②商品検索一覧
### 概要
- トップページの検索フォームから商品をあいまい検索できる機能
- 商品検索画面のサイドバーから条件を指定して詳細検索ができる機能
#### 担当内容(フロントエンド)
- haml,scssを使用し商品検索一覧のマークアップ作業
- 検索結果が多い場合、複数のページに分けて表示
#### 担当内容(バックエンド)
- Ruby on Railsの”kaminari”というgemを使用し、ページネーション機能の実装
- 検索結果が新しく出品された商品から表示されるように実装
- 商品を選択すると各商品の詳細ページに遷移できる
- Ruby on Railsの”ransack”というgemを使用し、詳細検索を実装


# DB設計
![freemarket_sample_70c_ER図](https://user-images.githubusercontent.com/59963342/77608611-17cc5780-6f61-11ea-9516-1676fec38e3c.png)

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
|user_id|references|foreign_key: true|d
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
