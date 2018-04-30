class ProductBlockCompleteInfoSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :product

  def product
    ProductSerializer.new(object.product, root: false)
  end
end
