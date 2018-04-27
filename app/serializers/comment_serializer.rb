class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :product_id, :created_at, :updated_at#, :user_id

  belongs_to :user
  # belongs_to :product
end
