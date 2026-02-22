module Api
  module V1
    class ReservationsController < ApplicationController
      def create
        reservation = CreateReservation.for(
          table_id: reservation_params[:table_id],
          diner_ids: reservation_params[:diner_ids],
          reservation_time: reservation_params[:reservation_time]
        )

        render json: ReservationSerializer.new(
          reservation,
          include: %i[table diners]
        ).serializable_hash, status: :created
      end

      private

      def reservation_params
        params.permit(:table_id, :reservation_time, diner_ids: [])
      end
    end
  end
end
