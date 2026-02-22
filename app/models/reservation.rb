class Reservation < ApplicationRecord
  DURATION = 2.hours

  belongs_to :table
  has_many :reservation_diners, dependent: :destroy
  has_many :diners, through: :reservation_diners

  scope :overlapping, ->(time) {
    where("reservation_time < ? AND reservation_time + interval '2 hours' > ?",
      time + DURATION, time)
  }

  validates :reservation_time, presence: true
  validates :diners, presence: true
  validate :no_overlapping_reservations
  validate :table_has_enough_capacity
  validate :restaurant_meets_dietary_restrictions

  private

  def no_overlapping_reservations
    return if table_id.blank? || reservation_time.blank?

    overlapping = Reservation.where(table_id: table_id).overlapping(reservation_time)

    overlapping = overlapping.where.not(id: id) if persisted?

    errors.add(:base, "Table is already reserved at this time") if overlapping.exists?
  end

  def table_has_enough_capacity
    return if table.blank? || diners.empty?

    if diners.size > table.capacity
      errors.add(:base, "Table capacity (#{table.capacity}) is insufficient for #{diners.size} diners")
    end
  end

  def restaurant_meets_dietary_restrictions
    return if table.blank? || diners.empty?

    required_restrictions = diners.flat_map(&:dietary_restrictions).uniq
    return if required_restrictions.empty?

    restaurant = table.restaurant
    restaurant_restriction_ids = restaurant.dietary_restrictions.pluck(:id)
    missing = required_restrictions.reject { |r| restaurant_restriction_ids.include?(r.id) }

    if missing.any?
      errors.add(:base, "Restaurant does not support dietary restrictions: #{missing.map(&:name).join(', ')}")
    end
  end
end
