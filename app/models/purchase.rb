class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :seller, class_name: User, foreign_key: :seller_id
  belongs_to :buyer, class_name: User, foreign_key: :buyer_id
  belongs_to :destiny, optional: true, class_name: Origin, foreign_key: :origin_id
  
end
