# encoding: UTF-8

require 'spec_helper'
require 'carrierwave/test/matchers'

describe 'FileUploader' do
  include CarrierWave::Test::Matchers
  include CarrierWave::RMagick

  let(:bill) { FactoryGirl.build(:bill) }
  let(:bill_file) { FactoryGirl.build(:bill_file) }

  before do
    @uploader = FileUploader.new(bill)
    FileUploader.enable_processing = true
  end

  after do
  	FileUploader.enable_processing = false
    @uploader.remove!
  end

  describe 'extension' do
    it 'should throw IntegrityError when assigning a file with not allowed extension' do
      other_format = FactoryGirl.build(:bill_file, filename: "example.pepper")

      expect { @uploader.store! (other_format) }.to raise_error(
      	CarrierWave::IntegrityError, /deve ser .pdf/)
    end
  end

  describe 'update_model' do
  	it 'should update url and filename attribute for bill' do
      @uploader.store!(bill_file)

      bill.url.should == @uploader.url
      bill.filename.should == @uploader.filename
    end
  end
end
