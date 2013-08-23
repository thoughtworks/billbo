# encoding: UTF-8

require 'spec_helper'

describe 'Billbo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:bill) { FactoryGirl.create(:bill) }

  context 'New Bill' do
    describe 'GET /bill/new' do
      describe 'when log in as admin' do
        before do
          log_in_as_admin
        end

        it 'renders new_bill' do
          get '/bill/new'

          last_response.should be_ok
          last_request.url.should =~ /bill\/new/
        end
      end

      describe 'when log in as not admin user' do
        before do
          log_in 'test@example.com'
        end

        it 'renders homepage ' do
          get '/bill/new'
          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should == homepage
        end
      end

      describe 'when not log in' do
        it 'renders auth' do
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

        after do
          logout
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

        it 'recognizes invalid bill and render new view with errors' do
          attributes = FactoryGirl.attributes_for(:bill)
          attributes[:issued_by] = ''
          expect {
            post '/bill/create', attributes
          }.to_not change { Bill.count }

          last_response.should be_ok
          last_response.body.should =~ /Empresa é um campo obrigatório/
        end
      end
    end
  end


  context 'Upload Bill Receipt' do
    describe 'GET /bill/receipt/:bill_id' do
      it "render upload_receipt view" do
        get '/bill/upload-receipt/1'

        last_response.should be_ok
        last_response.body.should =~ /upload_receipt/
      end
    end

    describe 'POST /bill/upload-receipt' do
      describe 'with valid data' do
        it 'updates a bill inserting its receipt data' do
          attrs = FactoryGirl.attributes_for(:receipt)

          id = bill.id
          post "/bill/upload-receipt/#{id}", attrs

          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should == homepage

          bill2 = Bill.find(id)
          bill2.receipt.contributor_email.should == attrs[:contributor_email]
        end
        it 'send an email to the admin with the receipt information' do
          admin = FactoryGirl.create(:admin)
          attrs = FactoryGirl.attributes_for(:receipt)

          Pony.should_receive :mail do  |params|
            params[:to].should == admin.email
            params[:from].should == attrs[:contributor_email]
            params[:subject].should include 'upload_receipt_subject'
            params[:html_body].should include attrs[:contributor_name],
                                              bill.issued_by,
                                              bill.total_amount.to_s,
                                              bill.due_date.to_s
            params[:via].should == :smtp
          end

          post "/bill/upload-receipt/#{bill.id}", attrs
        end
      end
      it 'recognizes invalid data and redirects' do
        attributes = FactoryGirl.attributes_for(:receipt)
        attributes[:contributor_email] = ''
        post "/bill/upload-receipt/#{bill.id}", attributes

        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should == "#{homepage}bill/upload-receipt/#{bill.id}"
      end
    end
  end


  context 'Bill Reservation' do
    context 'GET /bill/reserve/:bill_id' do
      it "render reserve_bill view" do
        get "/bill/reserve/#{bill.id}"

        last_response.should be_ok
        last_response.body.should =~ /reserve_bill/
      end
    end
    context 'POST /bill/reserve' do
      it 'creates a new reservation' do
        attrs = FactoryGirl.attributes_for(:reservation)

        id = bill.id
        post "/bill/reserve/#{id}", attrs

        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should == homepage

        last_bill = Bill.find(id)
        last_bill.reservations.last.email.should == attrs[:email]
        last_bill.reservations.last.phone_number.should == attrs[:phone_number]
        last_bill.reservations.last.bill.should == bill
      end
      it 'recognizes invalid data and redirects' do
        attributes = FactoryGirl.attributes_for(:reservation)
        attributes[:email] = ''
        post "/bill/reserve/#{bill.id}", attributes

        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should == "#{homepage}bill/reserve/#{bill.id}"
        last_response.body.should =~ /reserve_bill_fail/
      end
    end
  end
end
