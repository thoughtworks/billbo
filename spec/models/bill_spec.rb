# encoding: UTF-8

require 'spec_helper'

describe Bill do
  let(:bill) { FactoryGirl.build(:bill) }

  context :relations do
    it { should have_one(:receipt) }
    it { should have_one(:reservation) }
  end

  context :update do
    let(:new_attributes) {
      { 'id'           => 1,
        'ngo_id' => 1234,
        'issued_by'    => 'foo',
        'due_date'     => Date.today,
        'total_amount' => 1.0,
        'status'       => :waiting_confirmation,
        'url'          => "xxx",
        "filename"     => "bill.png"
      }
    }

    it 'is created with open status' do
      bill.save
      bill.status.should == :opened
    end

    it 'mass assigns fields successfully' do
      bill.update_attributes(new_attributes)

      bill.should be_valid
      bill.id.should_not == new_attributes['id']
      bill.attributes.except('_id').should == new_attributes.except('id')
    end

    it 'validates total_amount must be greater than 0.0' do
      bill.update_attributes(total_amount: -1)
      bill.errors.should have_key(:total_amount)
    end
  end

  context :validation do

    let(:fake_file) { double('file') }

    it 'validates that all fields are mandatory' do
      bill = Bill.new

      bill.should_not be_valid
      bill.errors.messages.should have(3).items
      bill.errors.messages.should have_key(:issued_by)
      bill.errors.messages.should have_key(:due_date)
      bill.errors.messages.should have_key(:total_amount)
    end

    it 'validates that status is invalid' do
      bill.update_attributes(status: :foo)
      bill.errors.should have_key(:status)
    end

    it 'validates that status is valid' do
      bill.update_attributes(status: :reserved)
      bill.should be_valid
    end

    it 'validates due_date is a valid date' do
      invalid_bill = FactoryGirl.build(:bill, due_date: '30/07/2013')
      invalid_bill.should_not be_valid
      invalid_bill.errors.should have_key(:due_date)
    end

    it 'validates if total amount is a number' do
      invalid_bill = FactoryGirl.build(:bill, total_amount: 'aaaa')

      invalid_bill.should_not be_valid
      invalid_bill.errors.should have_key(:total_amount)
      invalid_bill.errors[:total_amount][0].should match I18n.t(:not_a_number)
    end

    it 'validates the size of the file' do
      invalid_bill = Bill.new({file: fake_file})

      ten_mb = 20**20
      FileUploader.any_instance.stub_chain(:file, :size).and_return(ten_mb)

      invalid_bill.should_not be_valid
      invalid_bill.errors.should have_key(:file)
      invalid_bill.errors[:file][0].should match I18n.t(:exceeds_file_size)
    end

    it 'validates the extension of the file' do
      invalid_bill = Bill.new({file: FactoryGirl.build(:not_pdf_file)})

      invalid_bill.should_not be_valid
      invalid_bill.errors.should have_key(:file)
      invalid_bill.errors[:file][0].should match I18n.t('errors.messages.extension_white_list_error')
    end

  end

  context 'update reservation status' do
    it 'verify if the bill reservation status is updated back to opened' do
      bill.update_attributes(status: :reserved)
      reservation = bill.build_reservation(:email => 'test@xxx.com', :phone_number => '(81) 9999-1111')
      reservation.date = DateTime.yesterday
      reservation.save!

      Bill.update_reservations_status

      bill.reload.status.should == :opened
      reservation.reload.status.should == :inactive
    end
  end

  context :reserve do
    let(:reservation) { FactoryGirl.build(:reservation) }

    context "when no one already reserved it" do
      let(:invalid_reservation) { { phone_number: nil, email: nil } }
      before(:each) { bill.save }

      context "when reservation is valid" do
        it "should change bill status to reserved" do
          bill.status.should eq(:opened)
          bill.reservation.should be_nil

          bill.reserve reservation.as_json

          bill.status.should eq(:reserved)
          bill.reservation.should be_persisted
        end
      end

      context "when reservation is invalid" do
        it "should change bill status to reserved" do
          bill.status.should eq(:opened)
          bill.reservation.should be_nil

          bill.reserve invalid_reservation

          bill.status.should eq(:opened)
          bill.reservation.should_not be_persisted
        end
      end
    end
    context "when bill already reserved" do
      before do
        bill.save
        bill.reserve reservation.as_json
      end
      it "should not create a new reservation" do
        bill.reserve reservation.as_json
        bill.status.should eq(:reserved)
        bill.reservation.should be_persisted
      end
    end
  end

end
