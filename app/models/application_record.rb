class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  enum role: [:normal , :admin]
  enum gender: [:other , :male, :female]
end
