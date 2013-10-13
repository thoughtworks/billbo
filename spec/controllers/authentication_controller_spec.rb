# encoding: UTF-8

require 'spec_helper'

describe 'Authentication controller' do
  include Rack::Test::Methods

  let(:test_homepage_url){ '/' }

  describe 'GET /auth' do
    it 'redirects to an authorized url' do
      auth_callback = "#{homepage_url}oauth2callback?url=/"
      Auth.any_instance.stub(:authorize_url).with(auth_callback).and_return test_homepage_url

      get '/auth', url: test_homepage_url

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage_url
    end
  end

  describe 'GET /logout' do
    before do
      log_in_as_admin
    end

    it 'logs the user out and redirect to homepage' do
      get '/logout'

      last_request.session["email"].should be nil
      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage_url
    end
  end

  describe 'GET /oauth2callback' do
    it 'redirects to specified url and set session name, email' do
      auth = Auth.new
      auth.stub(:name).and_return 'user'
      auth.stub(:email).and_return 'email'
      Auth.stub(:new).and_return auth

      get '/oauth2callback', {url: homepage_url, code: '2352'}

      last_response.should be_redirect
      follow_redirect!
      last_response.should be_ok
      last_request.url.should == homepage_url
    end
  end
end
