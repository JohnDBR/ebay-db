class Origin < ApplicationRecord
  belongs_to :user

  validates :country, :state, :city, :postal_code, :address, presence: true, on: :create

  before_save :format_downcase
  
  protected 
  def format_downcase
    self.country.downcase!
    self.state.downcase!
    self.city.downcase!
  end
end
