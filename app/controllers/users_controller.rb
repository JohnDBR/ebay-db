class UsersController < ApplicationController
  before_action :set_user, only: [:show]
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
    @current_user.update_attributes user_params 
    save_and_render @current_user
  end

  def destroy
    render_ok @current_user.destroy  
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
      :email
    )
  end
end
