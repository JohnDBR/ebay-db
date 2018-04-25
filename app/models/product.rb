class Product < ApplicationRecord
  validates :name, :category, :shipping_description, :price, :origin_id, presence: true, on: :create

  before_save :format_downcase

  belongs_to :user
  belongs_to :cover, optional: true, class_name: Picture, foreign_key: :picture_id, dependent: :destroy
  belongs_to :origin
  has_many :bids, dependent: :destroy 
  has_many :comments, dependent: :destroy
  has_many :purchases
  has_many :product_picture, dependent: :destroy

  def as_json(*)
    json = super
    if self.cover
      json = json.tap do |hash|
        hash["cover_url"] = self.cover.url
      end   
    else
      json = json.tap do |hash|
        hash["cover_url"] = nil
      end
    end
    if self.is_auction
      if !self.bids.empty?
        json = json.tap do |hash|
          hash["last_bid"] = self.bids.last.bid
        end
      else 
        json = json.tap do |hash|
          hash["last_bid"] = nil
        end
      end 
    end
    json = json.tap do |hash|
      hash["origin"] = self.origin
    end
    return json
  end

  protected
  def format_downcase
    self.name.downcase!
    self.shipping_description.downcase!
    self.description.downcase!
  end
end