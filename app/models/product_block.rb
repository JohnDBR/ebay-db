class ProductBlock < ApplicationRecord
  belongs_to :product 
  
  validates :blocked_stock, presence: true, on: :create
end
