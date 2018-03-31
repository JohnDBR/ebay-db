class Users::AdminsController < ApplicationController 
  before_action :is_current_user_admin
  before_action :set_user, only: [:update, :destroy, :block]
  
  def update
    @user.update_attributes user_params 
    save_and_render @current_user
  end

  def destroy
    render_ok @user.destroy
  end

  def block
    if !@user.tokens.nil?
      @user.tokens.map do |token| #.map is required to iterate through ActiveRecord::Associations::CollectionProxy element, it is not an array...
        token.destroy
      end
    end
    block = Block.new(user_id:params[:user_id].to_i)
    save_and_render block
  end

  def deblock
    block = Block.where(user_id:params[:user_id].to_i).first
    if block
      render_ok block.destroy
    else
      render json: {authorization: 'user is not blocked'}, status: :unprocessable_entity
    end  
  end

  private 
  def set_user
    @user = User.find params[:user_id]
  end

  def user_params
    params.permit(
      :company,
      :name,
      :username,
      :password,
      :email, 
      :role
    )
  end
end