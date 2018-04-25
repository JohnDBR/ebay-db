class PicturesController < ApplicationController
  before_action :set_picture, only: [:destroy]
  before_action :set_product, only: [:cover]

  def profile
    trans = Transmission.new
    if trans.create_picture(params)
      if @current_user.picture then @current_user.picture.destroy end 
      @current_user.update_attribute(:picture_id, trans.picture.id) 
      save_and_render @current_user #render bla bla...
    else
      render json: trans.errors, status: :unprocessable_entity
    end
  end

  def cover
    if is_my_product?
      if picture_does_not_have_purchases?(@product.cover)
        trans = Transmission.new
        if trans.create_picture(params)
          # @product.cover.destroy
          @product.update_attribute(:picture_id, trans.picture.id) 
          save_and_render @product #render bla bla...
        else
          render json: trans.errors, status: :unprocessable_entity
        end
      end
    end
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

  # def create_picture
  #   file_name = Picture.set_name
  #   upload_response = Cloudinary::Uploader.upload(params[:image], :public_id => file_name)
  #   @picture = Picture.new(name:file_name, url:upload_response["url"])
  #   if @picture.save then return true else render json: {error: 'upload fail'}, status: :unprocessable_entity ; return false end
  # end

  def picture_does_not_have_purchases?(picture)
    return true unless picture
    Product.where(picture_id: picture.id).includes(:purchases).first.purchases.empty? #sobra....
  end

  def is_my_product?
    if @product.user_id == @current_user.id then true else permissions_error ; false end
  end
end
