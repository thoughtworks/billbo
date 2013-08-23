# encoding: UTF-8

# encoding: UTF-8

class Bill
  include Mongoid::Document
  include CarrierWave::Mount

  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :barcode, type: String
  field :status, type: Symbol, default: :opened
  field :url, type: String
  field :filename, type: String
  mount_uploader :image, FileUploader

  before_create :escape_fields
  validate :date_is_before_today

  validates_presence_of :issued_by, :due_date, :total_amount, :barcode
  validates :status, inclusion: { in: [:paid, :opened, :reserved] }
  validates_uniqueness_of :barcode
  validates_numericality_of :barcode
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  has_one :receipt
  has_many :reservations

  def self.update_reservations_status
    reserved_bills = self.where(status: :reserved)
    reserved_bills.each do |reserved_bill|
      if reserved_bill.reservations.where(status: :active, :date.lte => DateTime.now - 1).count > 0
        reserved_bill.reservations.where(status: :active).update(status: :inactive)
        reserved_bill.status = :opened
        reserved_bill.save
      end
    end
  end

  private

  def date_is_before_today
    if self.due_date && self.due_date < Date.today
      self.errors.add(:due_date, "#{t.after_yesterday}")
    end
  end

  def escape_fields
    self.issued_by = h self.issued_by
    self.barcode = h self.barcode
  end
end
