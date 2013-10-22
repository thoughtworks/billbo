# encoding: UTF-8

require 'spec_helper'

describe 'Bills controller' do
  include Rack::Test::Methods
  
  let(:ngo) { FactoryGirl.create(:ngo) }
  
  context 'NGO exists' do
    context 'GET /ngo/:id' do 
      it "renders ngo page" do
        get "ngo/#{ngo.id}"
        
        last_response.should be_ok
        last_response.body.should match ngo.name
        last_response.body.should match ngo.description
        last_response.body.should include ngo.phone
        last_response.body.should match ngo.website
        last_response.body.should match ngo.email
        last_response.body.should match ngo.contact
      end
    end
  end
end