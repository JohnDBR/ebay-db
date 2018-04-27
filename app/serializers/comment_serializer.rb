class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :product_id#, :user_id

  belongs_to :user
  # belongs_to :product
end
