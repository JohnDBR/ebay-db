class ProductPictureSerializer < ActiveModel::Serializer
  attributes :id, :picture

  # belongs_to :picture
  def picture
    object.picture
  end
  # belongs_to :product
end
