class Product < ApplicationRecord

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :lead_time
  belongs_to_active_hash :condition
  belongs_to_active_hash :delivery_pay

  
  has_many :comments
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  # belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  # belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
  belongs_to :user
  belongs_to :category



  
  validates :user_id, :condition_id, :category_id, :delivery_pay_id, :prefecture_id, :lead_time_id, :status, presence: true
  validates :item_name, presence: true, length: { maximum: 40 }
  validates :item_detail, presence: true, length: { maximum: 1000}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 300, less_than: 10000000}
  validates :images, presence: true, length: {manimum: 1, maximum: 10}

  def self.search(search)
    return Product.all unless search
    Product.where(['item_name LIKE ?', "%#{search}%"])
  end

end

