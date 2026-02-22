require "test_helper"

class SearchRestaurantsTest < ActiveSupport::TestCase
  test "returns restaurants matching all dietary restrictions with available tables" do
    results = SearchRestaurants.for(
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: 1.day.from_now.change(hour: 19).iso8601
    )

    restaurant_names = results.map { |r| r[:restaurant].name }
    assert_includes restaurant_names, "Green Garden"
    assert_not_includes restaurant_names, "The Steakhouse"
    assert_not_includes restaurant_names, "Classic Diner"
  end

  test "returns restaurants with no restrictions when diners have none" do
    results = SearchRestaurants.for(
      diner_ids: [ diners(:bob).id ],
      reservation_time: 1.day.from_now.change(hour: 19).iso8601
    )

    restaurant_names = results.map { |r| r[:restaurant].name }
    assert_includes restaurant_names, "Green Garden"
    assert_includes restaurant_names, "The Steakhouse"
    assert_includes restaurant_names, "Classic Diner"
  end

  test "excludes tables with insufficient capacity" do
    results = SearchRestaurants.for(
      diner_ids: [ diners(:jack).id, diners(:jill).id, diners(:jane).id ],
      reservation_time: 1.day.from_now.change(hour: 19).iso8601
    )

    green_garden_result = results.find { |r| r[:restaurant].name == "Green Garden" }
    assert green_garden_result
    capacities = green_garden_result[:available_tables].map(&:capacity)
    assert_includes capacities, 4
    assert_not_includes capacities, 2
  end

  test "excludes tables with overlapping reservations" do
    time = 1.day.from_now.change(hour: 19)
    Reservation.create!(table: tables(:green_garden_large), reservation_time: time, diners: [ diners(:bob) ])

    results = SearchRestaurants.for(
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: time.iso8601
    )

    green_garden_result = results.find { |r| r[:restaurant].name == "Green Garden" }
    assert green_garden_result
    available_table_ids = green_garden_result[:available_tables].map(&:id)
    assert_not_includes available_table_ids, tables(:green_garden_large).id
    assert_includes available_table_ids, tables(:green_garden_small).id
  end

  test "excludes restaurant when all suitable tables are reserved" do
    time = 1.day.from_now.change(hour: 19)
    Reservation.create!(table: tables(:green_garden_large), reservation_time: time, diners: [ diners(:bob) ])
    Reservation.create!(table: tables(:green_garden_small), reservation_time: time, diners: [ diners(:bob) ])

    results = SearchRestaurants.for(
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: time.iso8601
    )

    green_garden_result = results.find { |r| r[:restaurant].name == "Green Garden" }
    assert_nil green_garden_result
  end

  test "includes tables when reservation does not overlap" do
    time = 1.day.from_now.change(hour: 19)
    Reservation.create!(table: tables(:green_garden_large), reservation_time: time, diners: [ diners(:bob) ])

    results = SearchRestaurants.for(
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: (time + 2.hours).iso8601
    )

    green_garden_result = results.find { |r| r[:restaurant].name == "Green Garden" }
    assert green_garden_result
    assert green_garden_result[:available_tables].any? { |t| t.capacity == 4 }
  end
end
