class User < ApplicationRecord
  has_secure_password

  validates :email, :username, presence: true, uniqueness: true
  validates :password, :role, :email, :name, :birthdate, :gender, presence: true, on: :create

  before_save :format_downcase

  belongs_to :picture, optional: true, dependent: :destroy
  has_one :block, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :origins, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bids, dependent: :destroy 
  has_many :sold_products, :class_name => 'Purchase', :foreign_key => 'seller_id'
  has_many :bought_products, :class_name => 'Purchase', :foreign_key => 'buyer_id'

  def as_json(*)
    super.tap do |hash|
      hash["profile_picture"] = self.picture
    end   
  end

  protected 
  def format_downcase
    self.name.downcase!
    self.email.downcase!
    self.username.downcase!
  end
end
