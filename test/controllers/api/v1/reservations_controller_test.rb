require "test_helper"

class Api::V1::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "create returns a reservation in JSON:API format" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19).iso8601

    post api_v1_reservations_url, params: {
      table_id: table.id,
      diner_ids: [ diners(:jack).id, diners(:jill).id ],
      reservation_time: time
    }, as: :json

    assert_response :created
    json = JSON.parse(response.body)

    assert_equal "reservation", json.dig("data", "type")
    assert json["data"]["relationships"].key?("table")
    assert json["data"]["relationships"].key?("diners")
    assert json.key?("included")
  end

  test "create persists the reservation" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19).iso8601

    assert_difference "Reservation.count", 1 do
      post api_v1_reservations_url, params: {
        table_id: table.id,
        diner_ids: [ diners(:jack).id ],
        reservation_time: time
      }, as: :json
    end
  end

  test "create returns 422 for overlapping reservation" do
    table = tables(:green_garden_large)
    time = 1.day.from_now.change(hour: 19)

    Reservation.create!(table: table, reservation_time: time, diners: [ diners(:bob) ])

    post api_v1_reservations_url, params: {
      table_id: table.id,
      diner_ids: [ diners(:jill).id ],
      reservation_time: (time + 30.minutes).iso8601
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any? { |e| e.include?("already reserved") }
  end

  test "create returns 404 for non-existent table" do
    post api_v1_reservations_url, params: {
      table_id: 999999,
      diner_ids: [ diners(:jack).id ],
      reservation_time: 1.day.from_now.iso8601
    }, as: :json

    assert_response :not_found
  end

  test "create returns 422 when table capacity is exceeded" do
    table = tables(:green_garden_small)

    post api_v1_reservations_url, params: {
      table_id: table.id,
      diner_ids: [ diners(:jack).id, diners(:jill).id, diners(:jane).id ],
      reservation_time: 1.day.from_now.iso8601
    }, as: :json

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any? { |e| e.include?("insufficient") }
  end
end
