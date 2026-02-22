class ReservationSerializer
  include JSONAPI::Serializer

  attributes :reservation_time

  belongs_to :table, serializer: TableSerializer
  has_many :diners, serializer: DinerSerializer
end
