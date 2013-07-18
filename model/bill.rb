class Bill
  include Mongoid::Document

  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :barcode, type: String
  field :status, type: Symbol, default: :opened

  validates :issued_by, :due_date, :total_amount, :barcode, presence: true
  validates :status, inclusion: { in: [:paid, :opened, :reserved] }
  validates :barcode, uniqueness: true

  attr_accessible :issued_by, :due_date, :total_amount, :barcode, :status
end
