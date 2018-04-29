class BidSerializer < ActiveModel::Serializer
  attributes :id, :bid, :created_at, :updated_at

  # has_one :user
  has_one :product
end
