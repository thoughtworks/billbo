require 'spec_helper'

describe 'Billbo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    let(:bills) { [FactoryGirl.build_stubbed(:bill)] }

    it 'assigns all bills as @bills' do
      Bill.should_receive(:where).with(status: :opened).and_return(bills)

      get '/'

      last_response.should be_ok
    end
  end

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


  describe 'GET /logout' do
    it 'should logout the user and redirect to homepage' do
      get '/logout'

      last_response.should be_redirect
      follow_redirect!

      last_response.should be_ok
      last_request.url.should == homepage
    end
  end

  def homepage
    'http://example.org/'
  end

end
