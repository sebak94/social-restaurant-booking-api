class ReservationDiner < ApplicationRecord
  belongs_to :reservation
  belongs_to :diner

  validates :diner_id, uniqueness: { scope: :reservation_id }
end
