class DinerRestriction < ApplicationRecord
  belongs_to :diner
  belongs_to :dietary_restriction

  validates :dietary_restriction_id, uniqueness: { scope: :diner_id }
end
