class Reservation
  include Mongoid::Document

  field :phone_number, type: String
  field :email, type: String
  field :date, type: DateTime, default: -> { DateTime.now }
  field :active_until, type: DateTime, default: -> { 24.hours.from_now }

  attr_accessible :email, :phone_number

  before_create :escape_fields
  validates_presence_of :phone_number, :email

  belongs_to :bill

  private
  def escape_fields
    self.phone_number = h self.phone_number
    self.email = h self.email
  end
end