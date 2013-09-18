# encoding: UTF-8

require 'spec_helper'

describe 'Bills controller' do
  include Rack::Test::Methods

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
          last_response.body.should include("Conta criada com sucesso")
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
        last_response.body.should =~ /Ocorreu um erro ao reservar a conta/
      end
    end
  end
  
  context 'Bill Update' do
    context 'GET /bill/update/:bill_id' do
      before do
        log_in_as_admin
      end
      
      it "render update_bill view" do
        get "/bill/update/#{bill.id}"

        last_response.should be_ok
        last_response.body.should =~ /update_bill/
      end
    end
    
    context 'POST /bill/update/:bill_id' do
      before do
        log_in_as_admin
      end

      it 'updates a bill sucessfully' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        id = bill.id
        
        expect {
          post "/bill/update/#{id}", attrs_to_update
        }.to_not change { Bill.count }
     
        last_bill = Bill.find(id)
        last_bill.issued_by.should == attrs_to_update[:issued_by]
        last_bill.due_date.day.should == attrs_to_update[:due_date].day
        last_bill.due_date.month.should == attrs_to_update[:due_date].month
        last_bill.due_date.year.should == attrs_to_update[:due_date].year
        last_bill.total_amount.should == attrs_to_update[:total_amount].to_f
        last_bill.barcode.should == attrs_to_update[:barcode]
      end
      
      it 'recognizes invalid data (due_date) and redirect' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        attrs_to_update[:due_date] = '32/12/2013'
        post "/bill/update/#{bill.id}", attrs_to_update

        last_response.should be_ok
        last_request.url.should == "#{homepage}bill/update/#{bill.id}"
        last_response.body.should =~ /Complete com uma data válida/
      end
      
      it 'recognizes invalid data (due_date before today) and redirect' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        attrs_to_update[:due_date] = '17/09/2013'
        post "/bill/update/#{bill.id}", attrs_to_update

        last_response.should be_ok
        last_request.url.should == "#{homepage}bill/update/#{bill.id}"
        last_response.body.should =~ /não pode ser anterior a hoje/
      end
      
      it 'recognizes invalid data (barcode) and redirect' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        attrs_to_update[:barcode] = 'AAA'
        post "/bill/update/#{bill.id}", attrs_to_update

        last_response.should be_ok
        last_request.url.should == "#{homepage}bill/update/#{bill.id}"
        last_response.body.should include("Código de barras deve ser um valor numérico")
      end
      
    end
  end
end
