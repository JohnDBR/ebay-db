class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :set_buyer_score, :set_seller_score, :set_was_shipped, :set_was_delivered]
  before_action :set_product, only: [:finish_auction, :set_destination]

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
    if is_my_sale? 
      if valid_score? params[:buyer_score]
        if was_delivered?
          if buyer_scored?
            @purchase.update_attribute(:buyer_score, params[:buyer_score])
            save_and_render @purchase
          end
        end
      end
    end
  end

  def set_seller_score
    if is_my_purchase? 
      if valid_score? params[:seller_score]
        if was_delivered?
          if seller_scored?
            @purchase.update_attribute(:seller_score, params[:seller_score])
            save_and_render @purchase       
          end
        end
      end
    end
  end

  def set_was_shipped
    if is_my_sale?
      if !@purchase.destiny.nil?
        if !@purchase.was_shipped
          @purchase.update_attribute(:was_shipped, true)
          save_and_render @purchase
        else
          render json: {authorization: 'product has been shipped'}, status: :unprocessable_entity 
        end  
      else
        render json: {authorization: 'destiny not set'}, status: :unprocessable_entity
      end
    end
  end

  def set_was_delivered
    if is_my_purchase?
      if @purchase.was_shipped
        if !@purchase.was_delivered
          @purchase.update_attribute(:was_delivered, true)
          save_and_render @purchase
        else
          render json: {authorization: 'product has been delivered'}, status: :unprocessable_entity
        end
      else
        render json: {authorization: 'product has not been shipped'}, status: :unprocessable_entity
      end
    end
  end

  def set_destination
    if is_my_destiny?(params)
      if @purchase.destiny.nil?
        @purchase.update_attribute(:origin_id, @origin.id)
        save_and_render @purchase
      else 
        render json: {authorization: 'destiny was set'}, status: :unprocessable_entity ; false 
      end
    end
  end

  def create
    errors = {}
    result = []
    params.each do |key, options|
      if key.include?("product")
        options = JSON.parse(options)
        @product = Product.find options["product_id"]
          if is_the_destiny_mine?(options)
            if @product.stock >= options["quantity"] 
              purchase = Purchase.new(buyer_id:@current_user.id, seller_id:@product.user.id, product_id:@product.id, quantity:options["quantity"], total_price:(@product.price*options["quantity"]), destiny:@origin)
              @product.update_attribute(:stock, @product.stock - options["quantity"])
              if purchase.save and @product.save
                result << Array.new([purchase, @product])
              else
                errors["transaction_errors_on_#{key}"] = Array.new([purchase.errors.messages, @product.errors.messages])
              end
            else 
              errors["product#{options["product_id"]}"] = "ingress a valid quantity" 
            end
          else
            errors["product#{options["product_id"]}"] = "the destiny is not mine" 
          end
      end
    end
    if result.empty?
      errors["empty_params"] = 'not enough arguments.' 
      render json: errors, status: :unprocessable_entity 
    else
      render json: {result: result, errors: errors}, status: :ok 
    end
  end

  private
  def set_purchase
    @purchase = Purchase.find params[:id]
  end

  def set_product
    @product = Product.find params[:product_id]
  end

  def im_selling?
    if @product.user_id == @current_user.id then true else permissions_error ; false end
  end

  def is_my_sale?
    if @purchase.seller_id == @current_user.id then true else permissions_error ; false end
  end

  def is_my_purchase?
    if @purchase.buyer_id == @current_user.id then true else permissions_error ; false end
  end

  def is_the_destiny_mine?(options)
    # pp origin_id = params[:destiny] or 
    (@origin = Origin.find(options["destiny"])).user_id == @current_user.id 
  end

  def is_my_destiny?(params)
    # pp origin_id = params[:destiny] or 
    (@origin = Origin.find(params[:origin_id])).user_id == @current_user.id 
  end

  def valid_score?(score)
    if 0 < score and score < 6 
      true 
    else 
      render json: {authorization: 'ingress a value between 1 and 5'}, status: :unprocessable_entity
      false
    end
  end

  def was_delivered? 
    if @purchase.was_delivered then true else render json: {authorization: 'product has not been delivered'}, status: :unprocessable_entity ; false end
  end

  def buyer_scored?
    if !@purchase.buyer_score.nil? then true else render json: {authorization: 'buyer was scored'}, status: :unprocessable_entity ; false end 
  end

  def seller_scored?
    if !@purchase.seller_score.nil? then true else render json: {authorization: 'seller was scored'}, status: :unprocessable_entity ; false end 
  end
end
