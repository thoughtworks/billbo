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
end
