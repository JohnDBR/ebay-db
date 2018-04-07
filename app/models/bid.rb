class Bid < ApplicationRecord
  validates :bid, presence: :true, on: :create

  belongs_to :user
  belongs_to :product

end
