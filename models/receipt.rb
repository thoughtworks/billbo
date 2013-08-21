class Receipt
  include Mongoid::Document
  include CarrierWave::Mount

  field :contributor_name, type: String
  field :contributor_email, type: String
  field :date, type: Date, default: -> { Time.now }
  field :url, type: String
  field :filename, type: String
  mount_uploader :image, FileUploader

  belongs_to :bill

  validates_presence_of :contributor_email

  before_create :escape_fields

  private
  def escape_fields
    self.issued_by = h self.issued_by
    self.barcode = h self.barcode
  end
end
