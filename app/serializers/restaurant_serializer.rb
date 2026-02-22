class RestaurantSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :endorsements do |restaurant|
    restaurant.dietary_restrictions.map { |dr| "#{dr.name}-friendly" }
  end

  has_many :available_tables, serializer: TableSerializer do |restaurant, params|
    params[:available_tables_by_restaurant][restaurant.id]
  end
end
