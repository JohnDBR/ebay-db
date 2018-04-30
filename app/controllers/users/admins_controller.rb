class Users::AdminsController < ApplicationController 
  before_action :is_current_user_admin
  before_action :set_user, only: [:block]

  def block
    if !@user.tokens.nil?
      @user.tokens.map do |token| #.map is required to iterate through ActiveRecord::Associations::CollectionProxy element, it is not an array...
        token.destroy
      end
    end
    block = Block.new(user_id:params[:user_id].to_i)
    if block.save 
      render json: block, serializer: BlockCompleteInfoSerializer, status: :ok
    else
      render json: {errors:block.errors.messages}, stauts: :unprocessable_entity
    end
  end

  def unblock
    block = Block.where(user_id:params[:user_id].to_i).first
    if block
      render json: block.destroy, serializer: BlockCompleteInfoSerializer, status: :ok
    else
      render json: {authorization: 'user is not blocked'}, status: :unprocessable_entity
    end  
  end

  def index_block
    render json: {
      blocks: ActiveModel::Serializer::CollectionSerializer.new(Block.all, serializer: BlockCompleteInfoSerializer)
    }, status: :ok
  end

  private 
  def set_user
    @user = User.find params[:user_id]
  end
end