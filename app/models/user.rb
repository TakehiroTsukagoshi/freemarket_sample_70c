class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :products,dependent: :destroy
  has_many :likes,dependent: :destroy
  has_many :liked_products, through: :likes, source: :product

  has_one :profile
  has_one :creditcard
  accepts_nested_attributes_for :profile
  
  validates :nickname, :encrypted_password, presence: true
  validates :password, presence: true, length: { minimum: 7 }, format: { with: /\A[a-zA-Z0-9]+\z/, message: '半角で入力してください' }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
  
  def already_liked?(product)
    self.likes.exists?(product_id: product.id)
  end

end
