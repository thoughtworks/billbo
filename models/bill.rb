class Bill
  include Mongoid::Document
  include CarrierWave::Mount
  include R18n::Helpers

  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :barcode, type: String
  field :status, type: Symbol, default: :opened
  field :url, type: String
  field :filename, type: String
  mount_uploader :image, FileUploader

  before_validation :validate_date

  validates_presence_of :issued_by, :due_date, :total_amount, :barcode
  validates :status, inclusion: { in: [:paid, :opened, :reserved] }
  validates_uniqueness_of :barcode
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  has_one :receipt
  has_many :reservations

  private

  def validate_date
    unless self.due_date && self.due_date >= Date.today
      self.errors.add(:due_date, i18n.after_yesterday)
    end
  end
end
