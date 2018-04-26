class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]
  before_action :set_product, only: [:product]
  before_action :set_product_picture, only: [:set_picture_as_cover]

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

  end

  def destroy
    render_ok @picture.destroy
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
