class BlockCompleteInfoSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :user

   def user  
    UserSerializer.new(object.user, root: false)
  end
end
