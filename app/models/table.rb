class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :reservations, dependent: :destroy

  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
