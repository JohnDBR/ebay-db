class UserSerializer < ActiveModel::Serializer
  attributes :id, :company, :name, :username, :role, :email, :birthdate, :gender, :created_at, :updated_at#, :picture_id

  belongs_to :picture
  has_one :block
end
