require "test_helper"

class CreateReservationTest < ActiveSupport::TestCase
  test "creates a reservation with diners" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19).iso8601

    reservation = CreateReservation.for(
      table_id: table.id,
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: time
    )

    assert reservation.persisted?
    assert_equal table, reservation.table
    assert_equal 2, reservation.diners.count
  end

  test "raises error when table does not exist" do
    assert_raises(ActiveRecord::RecordNotFound) do
      CreateReservation.for(
        table_id: 999999,
        diner_ids: [ diners(:jack).id ],
        reservation_time: 1.day.from_now.iso8601
      )
    end
  end

  test "raises error for overlapping reservation" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19)

    CreateReservation.for(
      table_id: table.id,
      diner_ids: [ diners(:jack).id ],
      reservation_time: time.iso8601
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      CreateReservation.for(
        table_id: table.id,
        diner_ids: [ diners(:jill).id ],
        reservation_time: (time + 30.minutes).iso8601
      )
    end
  end

  test "raises error when table capacity is exceeded" do
    table = tables(:green_garden_small)

    assert_raises(ActiveRecord::RecordInvalid) do
      CreateReservation.for(
        table_id: table.id,
        diner_ids: [ diners(:jack).id, diners(:jill).id, diners(:jane).id ],
        reservation_time: 1.day.from_now.iso8601
      )
    end
  end

  test "raises error when restaurant does not meet dietary restrictions" do
    table = tables(:steakhouse_table)

    assert_raises(ActiveRecord::RecordInvalid) do
      CreateReservation.for(
        table_id: table.id,
        diner_ids: [ diners(:jack).id ],
        reservation_time: 1.day.from_now.iso8601
      )
    end
  end
end
