class Reservation
  include Mongoid::Document

  field :phone_number, type: String
  field :email, type: String
  field :date, type: DateTime, default: -> { DateTime.now }
  field :active_until, type: DateTime, default: -> { 24.hours.from_now }

  attr_accessible :email, :phone_number

  validates_presence_of :phone_number, :email, :bill_id

  belongs_to :bill
end