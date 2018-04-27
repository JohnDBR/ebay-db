class PurchaseSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :total_price, :buyer_score, :seller_score, :was_shipped, :was_delivered, :product, :created_at, :updated_at#,:origin_id, :product_id

  # has_one :product 
  has_one :seller #change some belongs to for has_one
  has_one :buyer
  belongs_to :destiny
  
  def product
    ProductSerializer.new(object.product, root: false)
  end
end
