class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy, :bid]
  skip_before_action :get_current_user, only: [:index, :show] 

  def index
    render_ok Product.all
  end

  def show 
    render_ok @product
  end

  def create
    product = Product.new({user:@current_user}.merge product_params)
    save_and_render product
  end

  def update
    if @product.user_id == @current_user.id
      @product.update_attributes product_params 
      save_and_render @product
    else
      permissions_error
    end
  end

  def destroy
    if @product.user_id == @current_user.id
      render_ok @product.destroy
    elsif is_current_user_admin.nil?
      render_ok @product.destroy
    end
  end

  private 
  def set_product
    @product = Product.find params[:id]
  end

  def product_params
    params.permit(
      :name,
      :description,
      :category,
      :shipping_description,
      :origin_id,
      :stock, 
      :price,
      :is_used, 
      :is_auction
    )
  end
end
