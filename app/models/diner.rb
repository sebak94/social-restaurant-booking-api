class Diner < ApplicationRecord
  has_many :diner_restrictions, dependent: :destroy
  has_many :dietary_restrictions, through: :diner_restrictions
  has_many :reservation_diners, dependent: :destroy
  has_many :reservations, through: :reservation_diners

  validates :name, presence: true
end
