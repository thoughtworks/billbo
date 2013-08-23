require 'spec_helper'

describe 'Admin Controller' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:homepage_url){ '/' }

  describe 'GET /auth' do
  	it 'it should redirect to an authorized url' do
  	  auth_callback = "#{homepage}oauth2callback?url=/"
      Auth.any_instance.stub(:authorize_url).with(auth_callback).and_return homepage_url

      get '/auth', url: homepage_url

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage
  	end
  end

  describe 'GET /logout' do
  	before do
  	  log_in_as_admin
    end
    it 'should logout the user and redirect to homepage' do
      get '/logout'

      last_request.session["email"].should be nil
      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage
    end
  end

  describe 'GET /oauth2callback' do
  	it 'it should redirect to specified url and set session name, email' do
  	  auth = Auth.new
  	  auth.stub(:name).and_return 'user'
  	  auth.stub(:email).and_return 'email'
      Auth.stub(:new).and_return auth

      get '/oauth2callback', {url: homepage_url, code: '2352'}

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage
  	end
  end
end
