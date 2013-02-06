require './model/bill'

describe Bill do
  let(:bill) do
    Bill.new(issued_by: 'company')
  end 
  subject { bill }

  it { should be_valid }
end
