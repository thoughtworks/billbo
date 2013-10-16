# encoding: UTF-8

require 'spec_helper'

describe Bill do
  let(:bill) { FactoryGirl.build(:bill) }

  context :relations do
    it { should have_one(:receipt) }
    it { should have_many(:reservations) }
  end

  context :update do
    let(:new_attributes) {
      { 'id'           => 1,
        'ngo_id' => 1234,
        'issued_by'    => 'foo',
        'due_date'     => Date.today,
        'total_amount' => 1.0,
        'barcode'      => '1',
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
    it 'validates that all fields are mandatory' do
      bill = Bill.new

      bill.should_not be_valid
      bill.errors.messages.should have(4).items
      bill.errors.messages.should have_key(:issued_by)
      bill.errors.messages.should have_key(:due_date)
      bill.errors.messages.should have_key(:total_amount)
      bill.errors.messages.should have_key(:barcode)
    end

    it 'validates that status is invalid' do
      bill.update_attributes(status: :foo)
      bill.errors.should have_key(:status)
    end

    it 'validates that status is valid' do
      bill.update_attributes(status: :reserved)
      bill.should be_valid
    end

    it 'validates that barcode is unique' do
      bill.save
      new_bill = Bill.new(bill.attributes)

      new_bill.should_not be_valid
      new_bill.errors.should have_key(:barcode)
      new_bill.errors[:barcode][0] =~ /is already taken/
    end

    it 'validates due_date is a valid date' do
      invalid_bill = FactoryGirl.build(:bill, due_date: '30/07/2013')

      invalid_bill.should_not be_valid
      invalid_bill.errors.should have_key(:due_date)
    end
  end

  context 'update reservations status' do
    it 'verify if the bill reservation status is updated back to opened' do
      bill.update_attributes(status: :reserved)
      reservation = bill.reservations.create!(:email => 'test@xxx.com', :phone_number => '22222222')
      reservation.date = DateTime.yesterday
      reservation.save!

      Bill.update_reservations_status

      bill.reload.status.should == :opened
      reservation.reload.status.should == :inactive
    end
  end

  context :reserve do
    context "when no one already reserved it" do
      let(:reservation) { { phone_number: "(81) 8855-5522", email: "john@gmail.com"} }
      let(:invalid_reservation) { { phone_number: nil, email: nil} }

      before(:each) { bill.save }

      context "when reservation is valid" do
        it "should change bill status to reserved" do
          bill.status.should eq(:opened)
          bill.should have(0).reservations

          bill.reserve reservation

          bill.status.should eq(:reserved)
          bill.reservations.last.should be_persisted
        end
      end

      context "when reservation is invalid" do
        it "should change bill status to reserved" do
          bill.status.should eq(:opened)
          bill.should have(0).reservations

          bill.reserve invalid_reservation

          bill.status.should eq(:opened)
          bill.reservations.last.should_not be_persisted
        end
      end
    end
    context "when bill already reserved" do
      it "should not reserve it" do

      end
    end
  end

end
