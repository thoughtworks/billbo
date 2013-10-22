# encoding: UTF-8

require_relative "file_uploader"

class Bill
  include Mongoid::Document
  include CarrierWave::Mount

  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :status, type: Symbol, default: :opened
  field :url, type: String
  field :filename, type: String
  mount_uploader :image, FileUploader

  before_create :escape_fields

  validates_presence_of :issued_by, :due_date, :total_amount

  validate :date_is_before_today

  validates :total_amount, presence: true, allow_blank: true, numericality: { greater_than: 0 } 
  validates :status, inclusion: { in: [:opened, :reserved, :waiting_confirmation, :closed] }

  belongs_to :ngo
  has_one :receipt
  has_one :reservation

  scope :reserved, where(status: :reserved)

  def self.update_reservations_status
    reserved_bills = Bill.reserved
    reserved_bills.each do |reserved_bill|
      if Reservation.active_until_now_for reserved_bill
        reservation = Reservation.active_for reserved_bill
        reservation.update(status: :inactive)

        reserved_bill.status = :opened
        reserved_bill.save
      end
    end
  end

  def reserve(reservation)
    errors.add(:reservation, "#{I18n.t(:bill_already_reserved)}") if already_reserved?
    add_reservation(reservation) unless already_reserved?
  end

  def formatted_due_date
    due_date.strftime "%d/%m/%Y"
  end

  def image_url
    default_image
  end

  def default_image
    "/img/default_bill.png"
  end

  private

  def add_reservation(reservation)
    create_reservation reservation
    unless self.reservation.errors.any?
      self.status = :reserved
      save
    end
  end

  def already_reserved?
    self.status == :reserved && has_reservation?
  end

  def date_is_before_today
    if self.due_date && self.due_date < Date.today
      self.errors.add(:due_date, "#{I18n.t(:before_today)}")
    end
  end

  def escape_fields
    self.issued_by = h self.issued_by
  end
end
