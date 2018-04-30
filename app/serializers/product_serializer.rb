class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :category, :shipping_description, :stock, :price, :is_used, :is_auction, :created_at, :updated_at#, :picture_id, :origin_id, :user_id
  # attribute :product_picture, serializer: ProductPictureSerializer

  belongs_to :user
  belongs_to :cover
  belongs_to :origin
  has_many :bids 
  # has_many :comments
  has_many :product_picture
  has_one :product_block

  # def filter(keys)
  #   keys.delete(:avatar) unless options[:with_avatar]
  #   keys
  # end
end
