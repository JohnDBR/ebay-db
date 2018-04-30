class BidSerializer < ActiveModel::Serializer
  attributes :id, :bid, :created_at, :updated_at, :user#, :product

  # has_one :user
  belongs_to :product

  def user  
    UserSerializer.new(object.user, root: false)
  end

  # def product
  #   ProductSerializer.new(object.product, root: false).except(:bid)
  # end
end
