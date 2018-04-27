class ProductPictureSerializer < ActiveModel::Serializer
  attributes :id, :picture, :created_at, :updated_at

  # belongs_to :picture
  def picture
    object.picture
  end
  # belongs_to :product
end
