class RestaurantEndorsement < ApplicationRecord
  belongs_to :restaurant
  belongs_to :dietary_restriction

  validates :dietary_restriction_id, uniqueness: { scope: :restaurant_id }
end
