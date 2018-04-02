class Comment < ApplicationRecord
  validates :comment, presence: true, on: :create

  belongs_to :user
  belongs_to :product
 
end
