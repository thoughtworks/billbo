require "spec_helper"

describe "Receipts controller" do
  include Rack::Test::Methods
  let(:bill) { FactoryGirl.create(:bill) }

  describe "GET /bills/:bill_id/receipts/new" do
    it "renders view to upload a receipt" do
      get "/bills/#{bill.id}/receipts/new"

      last_response.should be_ok
      last_response.body.should =~ /upload_receipt/
    end
  end

  describe "POST /bills/:bill_id/receipts/create" do
    context "with valid data" do
      it "updates a bill inserting its receipt data" do
        attrs = FactoryGirl.attributes_for(:receipt)

        post "/bills/#{bill.id}/receipts/create", attrs

        last_response.should be_redirect
        follow_redirect!
        last_response.should be_ok
        last_request.url.should == share

        bill.reload.receipt.contributor_email.should == attrs[:contributor_email]
      end

      it "sends an email to the admin with the receipt information" do
        admin = FactoryGirl.create(:admin)
        attrs = FactoryGirl.attributes_for(:receipt)

        Pony.should_receive :mail do  |params|
          params[:to].should == admin.email
          params[:from].should == attrs[:contributor_email]
          params[:subject].should include "Pagamento carregado"
          params[:html_body].should include attrs[:contributor_name],
            bill.issued_by,
            bill.total_amount.to_s,
            bill.due_date.to_s
          params[:via].should == :smtp
        end

        post "/bills/#{bill.id}/receipts/create", attrs
      end
    end

    context "with invalid data" do
      it "recognizes invalid data and redirects" do
        attributes = FactoryGirl.attributes_for(:receipt)
        attributes[:contributor_email] = ''
        post "/bills/#{bill.id}/receipts/create", attributes

        last_response.should_not be_redirect
        last_response.should be_ok
        last_request.url.should == "#{homepage}bills/#{bill.id}/receipts/create"
      end
    end
  end
end
