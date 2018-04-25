class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  skip_before_action :get_current_user, only: [:index, :show] 

  def index
    render_ok Product.all
  end

  def show 
    render_ok @product
  end

  def create
    trans = Transmission.new
    product = Product.new({user:@current_user}.merge product_params)
    if product.save 
      if trans.create_picture(params)
        product.update_attribute(:picture_id, trans.picture.id)  
        render_ok product
      else
        render json: trans.errors, status: :unprocessable_entity
      end
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  def update
    if product_does_not_have_purchases?
      if @product.user_id == @current_user.id
        @product.update_attributes product_params 
        save_and_render @product
      else
        permissions_error
      end
    end
  end

  def destroy
    if product_does_not_have_purchases?
      if @product.user_id == @current_user.id
        render_ok @product.destroy
      elsif is_current_user_admin.nil?
        render_ok @product.destroy
      end
   end
  end

  private 
  def set_product
    @product = Product.find params[:id]
  end

  def product_does_not_have_purchases?
    if @product.purchases.empty? 
      true 
    else  
      render json: {authorization: 'You can not edit/destroy products that users already bought, we have to preserve the history'}, status: :unprocessable_entity
      false
    end
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
