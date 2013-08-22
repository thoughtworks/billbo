# encoding: utf-8

# encoding: UTF-8

require 'spec_helper'
require 'carrierwave/test/matchers'

describe 'FileUploader' do
  include CarrierWave::Test::Matchers
  include CarrierWave::RMagick

  let(:bill) { FactoryGirl.build(:bill) }
  let(:image) { FactoryGirl.build(:image) }

  before do
    @uploader = FileUploader.new(bill)
    FileUploader.enable_processing = true
  end

  after do
  	FileUploader.enable_processing = false
    @uploader.remove!
  end

  describe 'process' do
    it "should scale down a image to fit within 1000 by 1000 pixels" do
      @uploader.store!(image)

      image =  Magick::Image::read( @uploader.file.file ).first
      image.columns.should be <= 1000
      image.rows.should be <= 1000
    end
  end

  describe 'extension' do
    it "should throw IntegrityError when assigning a file with not allowed extension" do
      other_format = FactoryGirl.build(:image, filename: "example.pepper")

      expect { @uploader.store! (other_format) }.to raise_error(
      	CarrierWave::IntegrityError, /deve possuir uma das seguintes extensões: jpg, jpeg, gif ou png/)
    end
  end

  describe 'update_model' do
  	it 'should update url and filename attribute for bill' do
      @uploader.store!(image)

      bill.url.should == @uploader.url
      bill.filename.should == @uploader.filename
    end
  end
end
