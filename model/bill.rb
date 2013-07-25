
class Bill
  include Mongoid::Document
  include CarrierWave::Mount

  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :barcode, type: String
  field :status, type: Symbol, default: :opened
  field :image_url, type: String
  mount_uploader :image, FileUploader

  validates :issued_by, :due_date, :total_amount, :barcode, presence: true
  validates :status, inclusion: { in: [:paid, :opened, :reserved] }
  validates :barcode, uniqueness: true

end
