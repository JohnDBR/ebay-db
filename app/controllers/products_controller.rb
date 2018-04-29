class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  skip_before_action :get_current_user, only: [:index, :show, :search] 

  def index
    render_ok Product.all
  end

  def show 
    render_ok @product
  end

  def create
    product = Product.new({user:@current_user}.merge product_params)
    was_saved = product.save 
    if was_saved
      trans = Transmission.new
      trans.create_pictures(params, product)
      if !trans.pictures.empty? or trans.empty_params
        render_ok product
      else render json: trans.errors, status: :unprocessable_entity end
    else render json: product.errors, status: :unprocessable_entity end
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

  def search
    users = nil
    products = nil
    products_price_range = nil
    if !params[:input].nil?
      params[:input] = params[:input].downcase if params[:input].is_a?(String)
      users = User.search(params[:input])
      # products = Product.search(params[:input])
      products = if params[:input].is_a?(String) then
        if params[:input].include?("auction") or params[:input].include?("auctions") then
          Product.where(is_auction:true).order("created_at DESC")
        else
          Product.search(params[:input])
        end
      else
        Product.search(params[:input])
      end
    end
    if !params[:price_range].nil? and !products.nil?
      price_range = params[:price_range].split("-")
      products_price_range = products.where("price BETWEEN ? AND ?", price_range[0],  price_range[1]).order("created_at DESC")
    end
    if !params[:auction].nil? and !products.nil?
      if params[:auction]
        products = products.where(is_auction:true).order("created_at DESC")
      else
        products = products.where(is_auction:false).order("created_at DESC")
      end
    end
    if !params[:category].nil? and !products.nil?
        products = products.where(category:params[:category]).order("created_at DESC")
    end
    if !users.nil? and !products.nil?
      render json: {
        users: ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserSerializer),  
        products: ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer),
        products_price_range: if !products_price_range.nil? then
          ActiveModel::Serializer::CollectionSerializer.new(products_price_range, serializer: ProductSerializer)
        else 
          'No results for price range'
        end
        }, status: :ok
    else
      render json: {empty: 'no results'}, status: :unprocessable_entity
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
