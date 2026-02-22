require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "is valid with a table, reservation time and diners" do
    reservation = Reservation.new(
      table: tables(:green_garden_large),
      reservation_time: 1.day.from_now,
      diners: [ diners(:jack) ]
    )
    assert reservation.valid?
  end

  test "is invalid without a reservation time" do
    reservation = Reservation.new(table: tables(:green_garden_large), diners: [ diners(:jack) ])
    assert_not reservation.valid?
    assert_includes reservation.errors[:reservation_time], "can't be blank"
  end

  test "is invalid without diners" do
    reservation = Reservation.new(
      table: tables(:green_garden_large),
      reservation_time: 1.day.from_now
    )
    assert_not reservation.valid?
    assert_includes reservation.errors[:diners], "can't be blank"
  end

  test "detects overlapping reservations on the same table" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19, min: 0)

    Reservation.create!(table: table, reservation_time: time, diners: [ diners(:bob) ])

    overlapping = Reservation.new(table: table, reservation_time: time + 1.hour, diners: [ diners(:jack) ])
    assert_not overlapping.valid?
    assert_includes overlapping.errors[:base], "Table is already reserved at this time"
  end

  test "allows non-overlapping reservations on the same table" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19, min: 0)

    Reservation.create!(table: table, reservation_time: time, diners: [ diners(:bob) ])

    non_overlapping = Reservation.new(table: table, reservation_time: time + 2.hours, diners: [ diners(:jack) ])
    assert non_overlapping.valid?
  end

  test "allows overlapping reservations on different tables" do
    time = 1.day.from_now.change(hour: 19, min: 0)

    Reservation.create!(table: tables(:green_garden_large), reservation_time: time, diners: [ diners(:bob) ])

    other_table = Reservation.new(table: tables(:steakhouse_table), reservation_time: time, diners: [ diners(:bob) ])
    assert other_table.valid?
  end

  test "validates table capacity for diners" do
    reservation = Reservation.new(
      table: tables(:green_garden_small),
      reservation_time: 1.day.from_now,
      diners: [ diners(:jack), diners(:jill), diners(:jane) ]
    )
    assert_not reservation.valid?
    assert reservation.errors[:base].any? { |e| e.include?("insufficient") }
  end

  test "validates restaurant dietary restrictions for diners" do
    reservation = Reservation.new(
      table: tables(:steakhouse_table),
      reservation_time: 1.day.from_now,
      diners: [ diners(:jack) ]
    )
    assert_not reservation.valid?
    assert reservation.errors[:base].any? { |e| e.include?("dietary restrictions") }
  end
end
