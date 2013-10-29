# encoding: UTF-8

class Reservation
  include Mongoid::Document

  field :ddd, type: String
  field :phone_number, type: String
  field :email, type: String
  field :date, type: DateTime, default: -> { DateTime.now }
  field :status, type: Symbol, default: :active

  attr_accessible :email, :ddd, :phone_number

  before_create :escape_fields
  validates_presence_of :email
  validates :status, inclusion: { in: [:active, :inactive] }

  validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }

  validates_length_of :ddd, :minimum => 2, :maximum => 2, :allow_blank => true
  validates_length_of :phone_number, :minimum => 8, :maximum => 10, :allow_blank => true

  belongs_to :bill

  scope :active_for, ->(bill) { where(bill_id: bill.id, status: :active) }

  def self.active_until_now_for(bill)
    active_until_now(bill).count > 0
  end

  private
  scope :active_until_now, ->(bill) { where(bill_id: bill.id, status: :active, :date.lte => DateTime.now - 1) }

  def escape_fields
    self.ddd = h self.ddd
    self.phone_number = h self.phone_number
    self.email = h self.email
  end
end
