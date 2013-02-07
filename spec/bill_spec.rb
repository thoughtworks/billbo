require 'spec_helper'

describe Bill do
  it 'finds a bill by id' do
    bill = Bill.find 4
    bill.id.should == 4
  end
end
