class Transmission
  attr_accessor :picture, :pictures, :errors

  def initialize
    @picture = nil
    @pictures = {}
    @errors = {}
  end

  def create_picture(params)
    file_name = Picture.set_name
    upload_response = Cloudinary::Uploader.upload(params[:image], :public_id => file_name)
    @picture = Picture.new(name:file_name, url:upload_response["url"])
    if @picture.save 
      return true 
    else 
      @errors[:upload_fail] = @picture.errors.messages 
      return false 
    end
  end

  def create_pictures(params)
    params.each do |key, options|
      if key.include?("image") or key.eql?("cover")
        file_name = Picture.set_name
        upload_response = Cloudinary::Uploader.upload(options, :public_id => file_name)
        picture = Picture.new(name:file_name, url:upload_response["url"])
        if picture.save
          @pictures[key] = picture
        else  
          @errors[:upload_fail] = picture.errors.messages 
        end
      end
    end
  end
end 