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
    describe 'when log in as admin' do
      before do
        log_in_as_admin
      end
      it 'should render new_bill ' do
        get '/bill/new'
        
        last_response.should be_ok
        last_request.url.should =~ /bill\/new/
      end
      after do
        logout
      end
    end
    describe 'when log in as not admin user' do
      before do
        log_in 'test@example.com'
      end
      it 'should render homepage ' do
        get '/bill/new'
        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should == homepage
      end
      after do
        logout
      end
    end
    describe 'when not log in' do
      it 'should render auth' do
        get '/bill/new'
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should =~ /auth/
      end
    end
  end

  describe 'POST /bill/create' do
    describe 'when log in as admin' do
      before do
        log_in_as_admin
      end
      it 'creates valid bill and redirects' do
        expect {
          post '/bill/create', FactoryGirl.attributes_for(:bill)
        }.to change { Bill.count }.by(1)

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
        expect {
          post '/bill/create', attributes
        }.to change { Bill.count }.by(0)
        
        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should =~ /bill\/new/
        last_response.body.should_not =~ /success/
        last_response.body.should =~ /error/
      end
      after do
        logout
      end
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
  
  def log_in_as_admin
    admin = FactoryGirl.create(:admin)
    log_in admin.email
  end

  def log_in email
    set_cookie "stub_email=#{email}"
  end

  def logout
    set_cookie ""
  end
end
