class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :seller, :class_name => 'User'
  belongs_to :buyer, :class_name => 'User'
  belongs_to :destiny, optional: true, :class_name => 'Origin'
  
end
