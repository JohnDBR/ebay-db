class ProductPicture < ApplicationRecord
  belongs_to :picture, dependent: :destroy
  belongs_to :product

  # def as_json(*)
  #   super.tap do |hash|
  #     hash["picture"] = self.picture
  #   end
  # end
end
