class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]
  before_action :set_product, only: [:cover]
  before_action :set_product_picture, only: [:set_picture_as_cover]

  def profile
    trans = Transmission.new
    if trans.create_picture(params)
      if @current_user.picture then @current_user.picture.destroy end 
      @current_user.update_attribute(:picture_id, trans.picture.id) 
      save_and_render @current_user 
    else
      render json: trans.errors, status: :unprocessable_entity
    end
  end

  def cover
    if is_my_product?
      if picture_does_not_have_purchases?(@product.cover)
        trans = Transmission.new
        if trans.create_picture(params)
          prod_pic = ProductPicture.create(picture_id:trans.picture.id, product_id:@product.id)    
          @product.update_attribute(:picture_id, trans.picture.id) 
          save_and_render @product 
        else
          render json: trans.errors, status: :unprocessable_entity
        end
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
    Product.where(picture_id: picture.id).includes(:purchases).first.purchases.empty? #sobra....
  end

  def is_my_product?
    if @product.user_id == @current_user.id then true else permissions_error ; false end
  end
end
