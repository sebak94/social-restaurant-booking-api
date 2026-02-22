class DietaryRestriction < ApplicationRecord
  has_many :diner_restrictions, dependent: :destroy
  has_many :diners, through: :diner_restrictions
  has_many :restaurant_endorsements, dependent: :destroy
  has_many :restaurants, through: :restaurant_endorsements

  validates :name, presence: true, uniqueness: true
end
