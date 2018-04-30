class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :category, :shipping_description, :stock, :price, :is_used, :is_auction, :created_at, :updated_at, :user#, :picture_id, :origin_id, :user_id

  # belongs_to :user
  belongs_to :cover
  belongs_to :origin
  has_many :bids 
  # has_many :comments
  has_many :product_picture
  has_one :product_block

  def user
    UserSerializer.new(object.user, root: false)
  end
end
