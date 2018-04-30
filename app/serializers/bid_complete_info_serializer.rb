class BidCompleteInfoSerializer < ActiveModel::Serializer
  attributes :id, :bid, :created_at, :updated_at, :user, :product

  # has_one :user
  #? belongs_to :product

  # def extended_mode
  #   attributes :user, :product

  def user  
    UserSerializer.new(object.user, root: false)
  end

  def product
    ProductSerializer.new(object.product, root: false)
  end
end
