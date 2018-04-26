class Transmission
  attr_accessor :picture, :pictures, :errors, :empty_params

  def initialize
    @picture = nil
    @pictures = {}
    @errors = {}
    @empty_params = false
  end

  def create_picture(params, user)
    if params[:image].nil?
      @empty_params = true
      @errors[:upload_fail] = 'no photo to upload'
      return false
    else
      file_name = Picture.set_name
      upload_response = Cloudinary::Uploader.upload(params[:image], :public_id => file_name)
      @picture = Picture.new(name:file_name, url:upload_response["url"])
      if @picture.save 
        if user.picture then user.picture.destroy end 
        user.update_attribute(:picture_id, @picture.id)  
        return true 
      else 
        @errors[:upload_fail] = @picture.errors.messages 
        return false 
      end
    end
  end

  def create_pictures(params, product)
    @empty_params = true
    params.each do |key, options|
      if key.include?("image") or key.eql?("cover")
        @empty_params = false
        file_name = Picture.set_name
        upload_response = Cloudinary::Uploader.upload(options, :public_id => file_name)
        picture = Picture.new(name:file_name, url:upload_response["url"])
        pictures[key] = picture
        if picture.save
          ProductPicture.create(picture_id:picture.id, product_id:product.id) 
          if key.eql?("cover") then product.update_attribute(:picture_id, picture.id) end
        else  
          @errors[:upload_fail] = picture.errors.messages 
        end
      end
    end
    @errors[:upload_fail] = 'no photo to upload' if @empty_params
  end
end 