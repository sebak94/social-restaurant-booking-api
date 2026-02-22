class CreateReservation
  attr_reader :table_id, :diner_ids, :reservation_time

  def self.for(...)
    new(...).execute
  end

  def initialize(table_id:, diner_ids:, reservation_time:)
    @table_id = table_id
    @diner_ids = diner_ids
    @reservation_time = Time.zone.parse(reservation_time.to_s)
  end

  def execute
    ActiveRecord::Base.transaction do
      table = Table.lock("FOR UPDATE").find(table_id)

      Reservation.create!(
        table: table,
        reservation_time: reservation_time,
        diner_ids: diner_ids
      )
    end
  end
end
