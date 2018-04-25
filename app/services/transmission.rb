class Transmission
  attr_accessor :picture, :errors

  def initialize
    @picture = nil
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
end 