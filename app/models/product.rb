class Product < ApplicationRecord
  validates :name, :category, :shipping_description, :price, :origin_id, presence: true, on: :create

  before_save :format_downcase

  belongs_to :user
  belongs_to :cover, optional: true, class_name: Picture, foreign_key: :picture_id, dependent: :destroy
  belongs_to :origin
  has_many :bids, dependent: :destroy 
  has_many :comments, dependent: :destroy
  has_many :purchases
  has_many :product_picture, dependent: :destroy
  has_one :product_block, dependent: :destroy

  def self.search(search)
    categ = if categories[search].nil? then search else categories[search] end
    where("name LIKE ? OR category LIKE ? OR shipping_description LIKE ? OR price LIKE ? OR description LIKE ?", "%#{search}%", "%#{categ}%", "%#{search}%", "%#{search}%", "%#{search}%").order("created_at DESC")
  end

  protected
  def format_downcase
    self.name.downcase!
    self.shipping_description.downcase!
    self.description.downcase!
  end
end