class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  enum role: [:normal , :admin]
  enum gender: [:other , :male, :female]
  enum category: [
    :antiques, 
    :art, 
    :baby, 
    :books, 
    :business_and_industrial, 
    :cameras_and_photo, 
    :cellphones_and_accessories, 
    :clothing_shoes_and_accessories, 
    :coins_and_paper_money, 
    :collectibles, 
    :computers_tablets_and_networking, 
    :consumer_electronics, 
    :crafts, 
    :dolls_and_bears, 
    :dvds_and_movies, 
    :ebay_motors, 
    :entertainment_memorabilia, 
    :gift_cards_and_coupons, 
    :health_and_beauty, 
    :home_and_garden, 
    :jewelry_and_watches, 
    :music, 
    :musical_instruments_and_gear, 
    :pet_supplies, 
    :pottery_and_glass, 
    :real_estate, 
    :specialty_services, 
    :sporting_goods, 
    :sports_mem_cards_and_fan_shop, 
    :stamps, 
    :tickets_and_experiences, 
    :toys_and_hobbies, 
    :travel, 
    :video_games_and_consoles, 
    :everything_else
  ]

end
