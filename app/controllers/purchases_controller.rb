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
    purchase = nil 
    proceed = is_the_destiny_mine?
    if @product.is_auction and proceed
      purchase = Purchase.new(buyer_id:@current_user.id, seller_id:@product.user.id, quantity:@product.stock, total_price:@product.bids.last, destiny:)
      @product.update_attribute(:stock, 0)
    elsif @product.stock >= params[:quantity] and proceed
      purchase = Purchase.new(buyer_id:@current_user.id, seller_id:@product.user.id, quantity:params[:quantity], total_price:(@product.price*params[:quantity]), destiny:)
      @product.update_attribute(:stock, stock - params[:quantity])
    elsif proceed
      render json: {authorization: 'ingress a valid quantity'}, status: :unprocessable_entity
    else
      render json: {authorization: 'ingress a valid destiny'}, status: :unprocessable_entity
    end
    if purchase
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
    Origin.find(params[:destiny]).user_id == @current_user.id  
  end

  def valid_score?(score)
    if 0 < score and score < 6 
      true 
    else 
      render json: {authorization: 'ingress a value between 1 and 5'}, status: :unprocessable_entity
    end
  end
end
