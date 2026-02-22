class Restaurant < ApplicationRecord
  has_many :restaurant_endorsements, dependent: :destroy
  has_many :dietary_restrictions, through: :restaurant_endorsements
  has_many :tables, dependent: :destroy

  validates :name, presence: true
end
