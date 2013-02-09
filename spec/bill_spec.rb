require 'spec_helper'

describe Bill do
  let(:bill) { FactoryGirl.build(:bill) }

  it 'finds a bill by id' do
    bill.save
    bill_to_find = Bill.find(bill.id)
    bill_to_find.should === bill
  end

  it 'compares equal attributes of two bills' do
    bill2 = bill.clone
    (bill === bill2).should be_true
    (bill.eql? bill2).should be_false
  end

end
