class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :get_current_user, only: [:index, :show, :create] 

  def index 
    render_ok User.all
  end

  def show
    render_ok @user
  end

  def create
    user = User.new user_params
    save_and_render user
  end

  def update 
    if @user.id == @current_user.id
      @current_user.update_attributes user_params 
      save_and_render @current_user
    elsif is_current_user_admin.nil?
      params[:role] ||= @user.role
      @user.update_attributes({role:params[:role]}.merge user_params)
      save_and_render @user
    end
  end

  def destroy
    # if !(products = @user.products).empty?
    #   products.each { |product| }
    # end
    if @user.id == @current_user.id
      render_ok @current_user.destroy 
    elsif is_current_user_admin.nil?
      render_ok @user.destroy 
    end  
  end

  private 
  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.permit(
      :company,
      :name,
      :username,
      :password,
      :email,
      :birthdate,
      :gender
    )
  end
end
