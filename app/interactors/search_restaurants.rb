class SearchRestaurants
  attr_reader :diner_ids, :reservation_time

  def self.for(...)
    new(...).execute
  end

  def initialize(diner_ids:, reservation_time:)
    @diner_ids = diner_ids
    @reservation_time = Time.zone.parse(reservation_time.to_s)
  end

  def execute
    restaurants = restaurants_matching_dietary_restrictions
    restaurants.filter_map do |restaurant|
      available_tables = available_tables_for(restaurant)
      next if available_tables.empty?

      { restaurant: restaurant, available_tables: available_tables }
    end
  end

  private

  def diners
    @diners ||= Diner.where(id: diner_ids)
  end

  def required_restriction_ids
    @required_restriction_ids ||= DinerRestriction
      .where(diner_id: diner_ids)
      .distinct
      .pluck(:dietary_restriction_id)
  end

  def restaurants_matching_dietary_restrictions
    return Restaurant.all if required_restriction_ids.empty?

    Restaurant
      .joins(:restaurant_endorsements)
      .where(restaurant_endorsements: { dietary_restriction_id: required_restriction_ids })
      .group(:id)
      .having("COUNT(DISTINCT restaurant_endorsements.dietary_restriction_id) = ?", required_restriction_ids.size)
  end

  def available_tables_for(restaurant)
    reserved_table_ids = Reservation
      .joins(:table)
      .where(tables: { restaurant_id: restaurant.id })
      .overlapping(reservation_time)
      .pluck(:table_id)

    restaurant.tables
      .where("capacity >= ?", diners.size)
      .where.not(id: reserved_table_ids)
  end
end
