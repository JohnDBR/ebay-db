class Picture < ApplicationRecord
  validates :name, :url, presence: true

  before_destroy :delete_image

  def delete_image
    Cloudinary::Uploader.destroy(self.name)
  end

  def self.set_name
    begin
      name = SecureRandom.uuid.gsub(/-/, '')
    end while (Picture.where(name: name).any?) 
    name
  end
end
