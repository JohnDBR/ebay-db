class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]
  before_action :set_product, only: [:product, :index]
  before_action :set_product_picture, only: [:set_picture_as_cover, :destroy]

  def profile
    trans = Transmission.new
    if trans.create_picture(params, @current_user)
      save_and_render @current_user 
    else
      render json: trans.errors, status: :unprocessable_entity
    end
  end

  def product
    if is_my_product?
      if picture_does_not_have_purchases?(@product.cover)
        trans = Transmission.new
        trans.create_pictures(params, @product)
        if !trans.pictures.empty? and !trans.empty_params
          render_ok @product
        else render json: trans.errors, status: :unprocessable_entity end
      end
    end
  end

  def set_picture_as_cover
    if is_my_product?
      if @product.purchases.empty?
        @product.update_attribute(:picture_id, @picture.id)
        render_ok @product
      else 
        render json: {authorization: 'You can not edit/destroy products that users already bought, we have to preserve the history'}, status: :unprocessable_entity
      end
    end
  end

  def index
    render_ok @product.product_picture
  end

  def destroy
    if is_my_product?
      if @product.purchases.empty?
        @product_picture.destroy
        render_ok @picture.destroy
      else        
        render json: {authorization: 'You can not edit/destroy products that users already bought, we have to preserve the history'}, status: :unprocessable_entity
      end
    end
  end

  private
  def set_picture
    @picture = Picture.find params[:id]
  end

  def set_product
    @product = Product.find params[:product_id]
  end

  def set_product_picture
    @product_picture = ProductPicture.find params[:product_picture_id]
    @product = Product.find @product_picture.product_id
    @picture = Picture.find @product_picture.picture_id
  end

  def picture_does_not_have_purchases?(picture)
    return true unless picture
    if Product.where(picture_id: picture.id).includes(:purchases).first.purchases.empty? #sobra....
      true
    else
      render json: {authorization: 'You can not edit/destroy products that users already bought, we have to preserve the history'}, status: :unprocessable_entity
      false
    end
  end

  def is_my_product?
    if @product.user_id == @current_user.id then true else permissions_error ; false end
  end
end
