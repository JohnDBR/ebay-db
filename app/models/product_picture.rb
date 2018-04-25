class ProductPicture < ApplicationRecord
  belongs_to :picture, dependent: :destroy
  belongs_to :product

end
