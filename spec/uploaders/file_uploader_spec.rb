require 'spec_helper'
require 'carrierwave/test/matchers'

describe 'FileUploader' do
  include CarrierWave::Test::Matchers
  include CarrierWave::RMagick

  let(:bill) { FactoryGirl.build(:bill) }
  
  before do
    @uploader = FileUploader.new(bill)
    FileUploader.enable_processing = true
  end
  
  after do
  	FileUploader.enable_processing = false
    @uploader.remove!
  end
  
  describe 'process' do
    it "should scale down a image to fit within 500 by 500 pixels" do     
      path_to_file = File.join( File.dirname(__FILE__), "../../features/step_definitions/bill.png")
      @uploader.store!(File.open(path_to_file))

      image =  Magick::Image::read( @uploader.file.file ).first
      image.columns.should be <= 500
      image.rows.should be <= 500
    end
  end
  
  describe 'extension' do
    it "should throw IntegrityError when assignment not allowed extension" do
      path_to_file = File.join( File.dirname(__FILE__), "../../public/img/example.pepper")
      expect { @uploader.store! (File.open(path_to_file)) }.to raise_error(
      	CarrierWave::IntegrityError, /allowed types: jpg, jpeg, gif, png/)
    end
  end
  
  describe 'update_model' do
  	it 'should update url and filename attribute for bill' do
      path_to_file = File.join( File.dirname(__FILE__), "../../features/step_definitions/bill.png")
      @uploader.store!(File.open(path_to_file))
      
      bill.url.should == @uploader.url
      bill.filename.should == @uploader.filename
    end 
  end
end