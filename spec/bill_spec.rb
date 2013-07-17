require 'spec_helper'

describe Bill do
  let!(:bill) { FactoryGirl.build(:bill) }

  it 'saves a bill successfully' do
    expect { bill.save }.to change { Bill.count }.by(1)
    bill_found = Bill.find(bill.id)
    (bill == bill_found).should be_true
  end
end
