class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :set_buyer_score, :set_seller_score, :set_was_shipped, :set_was_delivered]
  before_action :set_product, only: [:create]

  def index
    render_ok @current_user.bought_products
  end

  def sold_index
    render_ok @current_user.sold_products
  end

  def show
    render_ok @purchase
  end

  def set_buyer_score
    if is_my_sale? and valid_score? params[:buyer_score]
      @purchase.update_attribute(:buyer_score, params[:buyer_score])
      save_and_render @purchase
    end
  end

  def set_seller_score
    if is_my_purchase? and valid_score? params[:seller_score]
      @purchase.update_attribute(:seller_score, params[:seller_score])
      save_and_render @purchase
    end
  end

  def set_was_shipped
    if is_my_sale?
      @purchase.update_attribute(:was_shipped, true)
      save_and_render @purchase
    end
  end

  def set_was_delivered
    if is_my_purchase?
      @purchase.update_attribute(:was_delivered, true)
      save_and_render @purchase
    end
  end

  def create
    if !@product.is_auction 
      if is_the_destiny_mine?
        if @product.stock >= params[:quantity]
          purchase = Purchase.new(buyer_id:@current_user.id, seller_id:@product.user.id, product_id:@product.id, quantity:params[:quantity], total_price:(@product.price*params[:quantity]), destiny:@origin)
          @product.update_attribute(:stock, @product.stock - params[:quantity])
          if purchase.save and @product.save
            render json: {purchase: purchase, product: @product}, status: :ok
          else
            render json: {purchase_errors:purchase.errors.messages, product_errors:@product.errors.messages}, status: :unprocessable_entity
          end
        else 
          render json: {authorization: 'ingress a valid quantity'}, status: :unprocessable_entity
        end
      end
    end
  end

  def finish_auction
    if is_my_sale? and is_an_auction?
      bids = @product.bids
      purchase = Purchase.new(buyer_id:bids.last.user_id, seller_id:@current_user.id, quantity:@product.stock, total_price:bids.last)
      @product.update_attribute(:stock, 0)
      if_save_succeeds(purchase, options) do |object|
        render json: {purchase: purchase, product: @product}, status: :ok
      end    
    end
  end

  private
  def set_purchase
    @purchase = Purchase.find params[:id]
  end

  def set_product
    @product = Product.find params[:product_id]
  end

  def is_my_sale?
    if @purchase.seller_id == @current_user.id then true else permissions_error ; false end
  end

  def is_my_purchase?
    if @purchase.buyer_id == @current_user.id then true else permissions_error end
  end

  def is_the_destiny_mine?
    if (@origin = Origin.find(params[:destiny])).user_id == @current_user.id 
      true 
    else
      render json: {authorization: 'ingress a valid destiny'}, status: :unprocessable_entity 
      false
    end
  end

  def is_an_auction?
    if @product.is_auction then true else permissions_error ; false end
  end

  def valid_score?(score)
    if 0 < score and score < 6 
      true 
    else 
      render json: {authorization: 'ingress a value between 1 and 5'}, status: :unprocessable_entity
    end
  end
end
