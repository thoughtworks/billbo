# encoding: UTF-8

require_relative "file_uploader"

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
  validates :contributor_email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }

  before_create :escape_fields

  private
  def escape_fields
    self.contributor_name = h self.contributor_name
    self.contributor_email = h self.contributor_email
  end
end
