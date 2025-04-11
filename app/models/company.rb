class Company < ApplicationRecord
  validates :fluid_shop, :authentication_token, :name, presence: true
  validates :authentication_token, uniqueness: true
end
