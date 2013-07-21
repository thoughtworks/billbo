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
    it 'creates bill and redirects' do
      post '/bill/create', FactoryGirl.attributes_for(:bill)

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should =~ /bill\/new/
    end
  end
end
