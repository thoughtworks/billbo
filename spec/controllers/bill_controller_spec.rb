require 'spec_helper'

describe 'Billbo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:bill) { FactoryGirl.create(:bill) }

  describe 'GET /bill/new' do
    it 'should render new_bill' do
      get '/bill/new'

      last_response.should be_ok
      last_request.url.should =~ /bill\/new/
    end
  end

  describe 'POST /bill/create' do
    it 'creates valid bill and redirects' do
      post '/bill/create', FactoryGirl.attributes_for(:bill)

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should =~ /bill\/new/
      last_response.body.should =~ /success/
      last_response.body.should_not =~ /error/
    end
    it 'recognizes invalid bill and redirects' do
      attributes = FactoryGirl.attributes_for(:bill)
      attributes[:issued_by] = ''
      post '/bill/create', attributes

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should =~ /bill\/new/
      last_response.body.should_not =~ /success/
      last_response.body.should =~ /error/
    end
  end

  describe 'GET /bill/receipt/:bill_id' do
    it "render upload_receipt view" do
      get '/bill/upload-receipt/1'

      last_response.should be_ok
      last_response.body.should =~ /Enviar recibo/
    end
  end

  describe 'POST /bill/upload-receipt' do
    it 'updates a bill inserting its receipt data' do
      attrs = FactoryGirl.attributes_for(:receipt)

      id = bill.id
      post "/bill/upload-receipt/#{id}", attrs

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == "http://example.org/"

      bill2 = Bill.find(id)
      bill2.contributor_email.should == attrs[:contributor_email]
    end
    it 'recognizes invalid data and redirects' do
      attributes = FactoryGirl.attributes_for(:receipt)
      attributes[:contributor_email] = ''
      post "/bill/upload-receipt/#{bill.id}", attributes

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == "http://example.org/bill/upload-receipt/#{bill.id}"
    end
  end

end
