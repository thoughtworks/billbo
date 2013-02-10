require 'spec_helper'

describe Bill do
  let!(:bill) { FactoryGirl.build(:bill) }

  it 'compares equal attributes of two bills' do
    bill_cloned = bill.clone
    (bill === bill_cloned).should be_true
    (bill.eql? bill_cloned).should be_false
  end

  it 'compares different attributes of two bills' do
    bill_different_id = FactoryGirl.build(:bill, id: 10)
    (bill_different_id === bill).should be_false
  end

  it 'creates a bill' do
    expect { Bill.create(bill) }.to change { Bill.count }.by(1)
  end

  it 'counts the amount of bills' do
    Bill.count.should == 0
    REDIS.hmset("bills:#{bill.id}",
                :issued_by, bill.issued_by,
                  :due_date, bill.due_date,
                  :total_amount, bill.total_amount,
                  :barcode, bill.barcode,
                  :bill_receipt, bill.bill_receipt,
                  :status, bill.status)
    Bill.count.should == 1
  end

  after do
    REDIS.del 'bills'
    REDIS.keys('bills:*').each { |key| REDIS.del key }
    REDIS.del 'ids:bills'
  end
end
