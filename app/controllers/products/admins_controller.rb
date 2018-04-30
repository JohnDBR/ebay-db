class Products::AdminsController < ApplicationController 
  before_action :is_current_user_admin
  before_action :set_product, only: [:block]

  def block
    block_product = ProductBlock.new(product_id:params[:product_id].to_i, blocked_stock:@product.stock)
    @product.update_attribute(:stock, 0) 
    save_and_render block_product
  end

  def unblock
    block_product = ProductBlock.where(product_id:params[:product_id].to_i).first
    if block_product
      @product.update_attribute(:stock, block_product.blocked_stock) 
      render_ok block_product.destroy
    else
      render json: {authorization: 'Product is not blocked'}, status: :unprocessable_entity
    end  
  end

  def index_block
    render_ok ProductBlock.all
  end

  private
  def set_product
    @product = Product.find params[:product_id]
  end
end