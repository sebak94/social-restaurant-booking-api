require "test_helper"

class Api::V1::RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "search returns restaurants matching dietary restrictions with available tables" do
    get api_v1_restaurants_search_url, params: {
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: 1.day.from_now.change(hour: 19).iso8601
    }

    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"].is_a?(Array)

    restaurant_names = json["data"].map { |r| r.dig("attributes", "name") }
    assert_includes restaurant_names, "Green Garden"
    assert_not_includes restaurant_names, "The Steakhouse"
  end

  test "search returns JSON:API format with included tables" do
    get api_v1_restaurants_search_url, params: {
      diner_ids: [ diners(:bob).id ],
      reservation_time: 1.day.from_now.change(hour: 19).iso8601
    }

    assert_response :success
    json = JSON.parse(response.body)

    assert json.key?("data")
    assert json.key?("included")

    first_restaurant = json["data"].first
    assert_equal "restaurant", first_restaurant["type"]
    assert first_restaurant["attributes"].key?("name")
    assert first_restaurant["attributes"].key?("endorsements")
    assert first_restaurant["relationships"].key?("available_tables")
  end

  test "search returns empty array when no restaurants match" do
    time = 1.day.from_now.change(hour: 19)

    Table.where(restaurant: restaurants(:green_garden)).each do |table|
      Reservation.create!(table: table, reservation_time: time, diners: [ diners(:bob) ])
    end

    get api_v1_restaurants_search_url, params: {
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: time.iso8601
    }

    assert_response :success
    json = JSON.parse(response.body)
    restaurant_names = json["data"].map { |r| r.dig("attributes", "name") }
    assert_not_includes restaurant_names, "Green Garden"
  end
end
