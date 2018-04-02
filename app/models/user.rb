class User < ApplicationRecord
  has_secure_password

  validates :email, :username, presence: true, uniqueness: true
  validates :password, :role, :email, :name, :birthdate, :gender, presence: true, on: :create

  before_save :format_downcase

  has_many :tokens, dependent: :destroy
  has_many :origins, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :block, dependent: :destroy
  
  protected 
  def format_downcase
    self.name.downcase!
    self.email.downcase!
    self.username.downcase!
  end
end
