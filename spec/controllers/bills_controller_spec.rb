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
          last_request.url.should match /bill\/new/
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
          last_request.url.should == homepage_url
        end
      end

      describe 'when not log in' do
        it 'renders auth' do
          get '/bill/new'
          last_response.should be_redirect
          follow_redirect!
          last_request.url.should match /auth/
        end
      end
    end

    describe 'POST /bill/new' do
      describe 'when log in as admin' do
        before do
          log_in_as_admin
        end

        after do
          logout
        end

        it 'creates valid bill and redirects' do
          expect {
            post '/bill/new', FactoryGirl.attributes_for(:bill)
          }.to change { Bill.count }.by(1)

          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should match /bill\/new/
          last_response.body.should match I18n.t(:bill_creation_ok)
        end

        it 'recognizes invalid bill and render new view with errors' do
          expect {
            post '/bill/new', {}
          }.to_not change { Bill.count }

          last_response.should be_ok
          last_response.body.should match /Empresa é um campo obrigatório/
          last_response.body.should match /Data de vencimento é um campo obrigatório/
          last_response.body.should match /Valor total é um campo obrigatório/

        end

      end
    end
  end

  context 'Bill Reservation' do
    context 'GET /bill/reserve/:bill_id' do
      it "render reserve_bill view" do
        get "/bill/reserve/#{bill.id}"

        last_response.should be_ok
        last_response.body.should match /reserve_bill/
      end
    end

    context 'POST /bill/reserve' do

      let(:attributes) { FactoryGirl.attributes_for(:reservation) }

      context 'when no user logged in' do
        it 'should not allow reservation creation' do
          post "/bill/reserve/#{bill.id}", attributes

          last_response.status.should == 401
        end
      end
      context 'when user is logged in' do
        before(:each) do
          log_in 'test@example.com'
        end

        def create_reservation!
          post "/bill/reserve/#{bill.id}", attributes
          follow_redirect!
        end

        it 'should allow reservation creation' do
          create_reservation!

          last_response.status.should == 200
        end

        context 'when data is valid' do

          it 'should create a reservation' do
            create_reservation!

            id = bill.id
            last_bill = Bill.find(id)
            reservation = last_bill.reservation

            reservation.email.should == attributes[:email]
            reservation.phone_number.should == attributes[:phone_number]
            reservation.bill.should == bill
          end

          it 'should redirect to homepage url on success reservation' do
            create_reservation!

            last_response.should be_ok
            last_request.url.should == homepage_url
          end

          context "when bill already reserved" do
            before do
              create_reservation!
            end
            it "should not create a new reservation" do
              create_reservation!

              last_request.url.should == "#{homepage_url}bill/reserve/#{bill.id}"
              last_response.body.should match /Conta já está reservada/
            end
          end
        end

        context 'when data is invalid' do
          it 'recognizes invalid data and redirects' do
            attributes[:email] = ''
            create_reservation!

            last_request.url.should == "#{homepage_url}bill/reserve/#{bill.id}"
            last_response.body.should match /Ocorreu um erro ao reservar a conta/
          end
        end

      end

    end
  end

  context 'Remove Bill' do
    context 'POST /bill/remove' do
      describe 'when logged in as admin' do
        before do
          log_in_as_admin
        end
        it 'should remove a bill' do
          bill.save!
          expect{
            delete "/bill/remove/#{bill.id}"
          }.to change { Bill.count }.by(-1)
        end
        it 'should render homepage' do
          delete "/bill/remove/#{bill.id}"
          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should == homepage_url
        end
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
        last_response.body.should match /update_bill/
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
      end

      it 'recognizes invalid data (due_date) and redirect' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        attrs_to_update[:due_date] = '32/12/2013'
        post "/bill/update/#{bill.id}", attrs_to_update

        last_response.should be_ok
        last_request.url.should == "#{homepage_url}bill/update/#{bill.id}"
        last_response.body.should match /Complete com uma data válida/
      end

      it 'recognizes invalid data (due_date before today) and redirect' do
        attrs_to_update = FactoryGirl.attributes_for(:bill)
        attrs_to_update[:due_date] = '17/09/2013'
        post "/bill/update/#{bill.id}", attrs_to_update

        last_response.should be_ok
        last_request.url.should == "#{homepage_url}bill/update/#{bill.id}"
        last_response.body.should match /não pode ser anterior a hoje/
      end

    end
  end

  context 'Close Bill' do
    context 'get /bill/close/:bill_id' do
      describe 'when log in as admin' do
        before do
          log_in_as_admin
          bill.status = :waiting_confirmation
        end

        after do
          logout
        end

        it 'should render homepage' do
          get "/bill/close/#{bill.id}"

          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should == homepage_url
          last_response.body.should match /bill_closed_ok/
        end
      end

      describe 'when log in as not admin user' do
        before do
          log_in 'test@example.com'
          bill.status = :waiting_confirmation
        end

        after do
          logout
        end

        it 'should render homepage with not and admin account message' do
          get "/bill/close/#{bill.id}"

          last_response.should be_redirect
          follow_redirect!
          last_response.should be_ok
          last_request.url.should == homepage_url
          last_response.body.should match /not_an_admin_account/
        end

        it 'shoud not close the bill' do
          get "/bill/close/#{bill.id}"

          bill.status.should == :waiting_confirmation
        end
      end
    end
  end
end