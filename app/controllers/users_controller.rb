class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :seller_score, :buyer_score]
  skip_before_action :get_current_user, only: [:index, :show, :create, :seller_score, :buyer_score] 

  def index 
    render_ok User.all
  end

  def show
    render json: {
      user: UserSerializer.new(@user),  
      product: ActiveModel::Serializer::CollectionSerializer.new(@user.products, serializer: ProductSerializer)
    }, status: :ok
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
    score = sold_products.inject(0) do |sum, element| 
      sum + if element.seller_score.nil? then 0 else element.seller_score end  
    end
    score = score.to_f / sold_products.inject(0){ |sum, element| sum + if element.seller_score.nil? then 0 else 1 end }
    if score.nan?
       render json: {authorization: 'no history to score'}, status: :unprocessable_entity
    else 
      render_ok score
    end
  end

  def buyer_score
    bought_products = @user.bought_products
    score = bought_products.inject(0) do |sum, element| 
      sum + if element.buyer_score.nil? then 0 else element.buyer_score end  
    end
    score = score.to_f / bought_products.inject(0){ |sum, element| sum + if element.buyer_score.nil? then 0 else 1 end }
    if score.nan?
      render json: {authorization: 'no history to score'}, status: :unprocessable_entity
    else 
      render_ok score
    end
  end

  def pending_actions
    actions = {}
    @current_user.sold_products.map do |sold_product|
      if sold_product.destiny.nil?
        actions["sold_product#{sold_product.id}"] = "you already finish the auction. wait destination address"
      else
        if sold_product.was_shipped
          if sold_product.was_delivered
            if sold_product.buyer_score.nil?
              actions["sold_product#{sold_product.id}"] = "score the buyer"
            end
          else
            actions["sold_product#{sold_product.id}"] = "you sent the product, wating deliver confirmation."
          end
        else
          actions["sold_product#{sold_product.id}"] = "send the product please, an user bought it."
        end
      end
    end
    @current_user.bought_products.map do |bought_product|
      if bought_product.destiny.nil?
        actions["bought_product#{bought_product.id}"] = "you won the auction of the product #{bought_product.product.id}. Enter your destination address"
      else
        if bought_product.was_shipped
          if bought_product.was_delivered
            if bought_product.seller_score.nil?
              actions["bought_product#{bought_product.id}"] = "score the seller"
            end
          else
            actions["bought_product#{bought_product.id}"] = "do you recived the product?"
          end
        else
          actions["bought_product#{bought_product.id}"] = "you bought the product, wait shipping confirmation."
        end
      end
    end
    Product.where(user_id:@current_user.id, is_auction:true).map do |product|
      if !product.bids.empty? and product.purchases.empty?
        actions["product_auction#{product.id}"] = "finish auction?. #{product.bids.length} bids were made."
      end  
    end      
    render json: actions, status: :ok
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
