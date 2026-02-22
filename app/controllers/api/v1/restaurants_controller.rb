module Api
  module V1
    class RestaurantsController < ApplicationController
      def search
        results = SearchRestaurants.for(
          diner_ids: search_params[:diner_ids],
          reservation_time: search_params[:reservation_time]
        )

        restaurants = results.map { |r| r[:restaurant] }
        available_tables_by_restaurant = results.to_h { |r| [ r[:restaurant].id, r[:available_tables] ] }

        render json: RestaurantSerializer.new(
          restaurants,
          params: { available_tables_by_restaurant: available_tables_by_restaurant },
          include: [ :available_tables ]
        ).serializable_hash
      end

      private

      def search_params
        params.permit(:reservation_time, diner_ids: [])
      end
    end
  end
end
