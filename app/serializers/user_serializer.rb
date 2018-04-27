class UserSerializer < ActiveModel::Serializer
  attributes :id, :company, :name, :username, :role, :email, :birthdate, :gender, :created_at, :updated_at#, :picture_id

  belongs_to :picture
  has_one :block
  # has_many :origins
  # has_many :products
  # has_many :comments
  # has_many :bids  
  # has_many :sold_products 
  # has_many :bought_products
end
