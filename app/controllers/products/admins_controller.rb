class Products::AdminsController < ApplicationController 
  before_action :is_current_user_admin
  before_action :set_product, only: [:block, :unblock]

  def block
    block_product = ProductBlock.new(product_id:params[:product_id].to_i, blocked_stock:@product.stock)
    @product.update_attribute(:stock, 0) 
    if block_product.save 
      render json: block_product, serializer: ProductBlockCompleteInfoSerializer, status: :ok
    else
      render json: {errors:block_product.errors.messages}, stauts: :unprocessable_entity
    end
  end

  def unblock
    block_product = ProductBlock.where(product_id:params[:product_id].to_i).first
    if block_product
      @product.update_attribute(:stock, block_product.blocked_stock)
      render json: block_product.destroy, serializer: ProductBlockCompleteInfoSerializer, status: :ok
    else
      render json: {authorization: 'Product is not blocked'}, status: :unprocessable_entity
    end  
  end

  def index_block
    render json: {
      products_block: ActiveModel::Serializer::CollectionSerializer.new(ProductBlock.all, serializer: ProductBlockCompleteInfoSerializer)
    }, status: :ok
  end

  private
  def set_product
    @product = Product.find params[:product_id]
  end
end