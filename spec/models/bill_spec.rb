require 'spec_helper'

describe Bill do
  let(:bill) { FactoryGirl.build(:bill) }

  it 'saves a bill successfully' do
    expect { bill.save }.to change { Bill.count }.by(1)
    bill_found = Bill.find(bill.id)
    (bill == bill_found).should be_true
  end

  context :update do
    let(:new_attributes) {
      { 'id'           => 1,
        'issued_by'    => 'foo',
        'due_date'     => Date.today,
        'total_amount' => 1.0,
        'barcode'      => '1',
        'status'       => :paid,
        'image_url'    => "xxx",
        "image"        =>"bill.png"
      }
    }

    it 'mass assigns fields successfully' do
      bill.update_attributes(new_attributes)

      bill.should be_valid
      bill.id.should_not == new_attributes['id']
      bill.due_date.should == new_attributes['due_date']
      bill.attributes.except('_id', 'due_date').should == new_attributes.except('id', 'due_date')
    end

    it 'update fields successfully' do
      bill.issued_by = new_attributes['issued_by']
      bill.due_date = new_attributes['due_date']
      bill.total_amount = new_attributes['total_amount']
      bill.barcode = new_attributes['barcode']
      bill.status = new_attributes['status']

      bill.should be_valid
      bill.issued_by == new_attributes['issued_by']
      bill.due_date == new_attributes['due_date']
      bill.total_amount == new_attributes['total_amount']
      bill.barcode == new_attributes['barcode']
      bill.status == new_attributes['status']
      bill.status == new_attributes['image_url']
    end
  end

  context :validation do
    it 'validates that all fields are mandatory' do
      bill = Bill.new

      bill.should_not be_valid
      bill.errors.should have(4).items
      bill.errors.should have_key(:issued_by)
      bill.errors.should have_key(:due_date)
      bill.errors.should have_key(:total_amount)
      bill.errors.should have_key(:barcode)
    end

    it 'validates that status is invalid' do
      bill.status = :foo

      bill.should_not be_valid
      bill.errors.should have_key(:status)
    end

    it 'validates that status is valid' do
      bill.status = :reserved
      bill.should be_valid
    end

    it 'validates that barcode is unique' do
      bill.save
      new_bill = Bill.new(bill.attributes)
      new_bill.image_url = 'xxx'

      new_bill.should_not be_valid
      new_bill.errors.should have_key(:barcode)
      new_bill.errors[:barcode][0] =~ /is already taken/
    end

  end
end
