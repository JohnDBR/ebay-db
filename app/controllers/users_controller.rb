class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :seller_score, :buyer_score]
  skip_before_action :get_current_user, only: [:index, :show, :create, :seller_score, :buyer_score] 

  def index 
    render_ok User.all
  end

  def show
    render_ok @user
  end

  def create
    user = User.new user_params
    was_saved = user.save
    if was_saved
      trans = Transmission.new
      if trans.create_picture(params, user) or trans.empty_params
        render_ok user
      else
        render json: {errors: trans.errors, user: user}, status: :unprocessable_entity
      end
    else
      render json: user.errors, status: :unprocessable_entity
    end
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
    if @current_user.sold_products.empty? and @current_user.bought_products.empty? 
      if @user.id == @current_user.id
        render_ok @current_user.destroy 
      elsif is_current_user_admin.nil?
        render_ok @user.destroy 
      end
    else
      render json: {authorization: 'we have to preserve the history of the web page'}, status: :unprocessable_entity
    end
  end

  def seller_score
    sold_products = @user.sold_products
    if (score = sold_products.inject{ |sum, element| sum + element }.to_f / sold_products.size).nan?
      render_ok 0
    else 
      render_ok score
    end
  end

  def buyer_score
    bought_products = @user.bought_products
    if (score = bought_products.inject{ |sum, element| sum + element }.to_f / bought_products.size).nan?
      render_ok 0
    else 
      render_ok score
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
