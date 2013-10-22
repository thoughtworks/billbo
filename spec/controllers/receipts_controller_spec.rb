require "spec_helper"

describe "Receipts controller" do
  include Rack::Test::Methods
  let(:bill) { FactoryGirl.create(:bill) }

  describe "GET /bills/:bill_id/receipts/new" do
    it "renders view to upload a receipt" do
      get "/bills/#{bill.id}/receipts/new"

      last_response.should be_ok
      last_response.body.should match /upload_receipt/
    end
  end

  describe "POST /bills/:bill_id/receipts/create" do

    let(:attributes) { FactoryGirl.attributes_for(:receipt) }

    context 'when no user logged in' do

      it 'should not allow receipt upload' do
        post "/bills/#{bill.id}/receipts/create", attributes
        last_response.status.should == 401
      end

    end

    context 'when user logged in' do

      before(:each) do
        log_in 'test@example.com'
      end

      def upload_receipt!
        post "/bills/#{bill.id}/receipts/create", attributes
        follow_redirect!
      end

      context "with valid data" do

        it 'should allow receipt upload' do
          upload_receipt!
          last_response.status.should == 200
        end

        it 'should redirect to share page' do
          upload_receipt!
          last_request.url.should == share_url
        end

        it "updates a bill inserting its receipt data" do
          upload_receipt!
          bill.reload.receipt.contributor_email.should == attributes[:contributor_email]
        end

        it "sends an email to the admin with the receipt information" do
          admin = FactoryGirl.create(:admin)

          Pony.should_receive :mail do  |params|
            params[:to].should == admin.email
            params[:from].should == attributes[:contributor_email]
            params[:subject].should include "Pagamento carregado"
            params[:html_body].should include attributes[:contributor_name],
              bill.issued_by,
              bill.total_amount.to_s,
              bill.due_date.to_s
            params[:via].should == :smtp
          end

          upload_receipt!
        end
      end

      context "with invalid data" do

        it "recognizes invalid data and redirects" do
          attributes[:contributor_email] = ''
          post "/bills/#{bill.id}/receipts/create", attributes

          last_response.should_not be_redirect
          last_response.should be_ok
          last_request.url.should == "#{homepage_url}bills/#{bill.id}/receipts/create"
        end

      end

    end
  end
end
