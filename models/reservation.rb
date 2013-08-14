class Reservation
  include Mongoid::Document

  field :phone_number, type: String
  field :email, type: String
  field :date, type: DateTime, default: -> { Time.now }

  validates_presence_of :phone_number, :email, :bill_id

  belongs_to :bill

end