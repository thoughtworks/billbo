require 'spec_helper'

describe Reservation do

  context :fields do
    its("date.to_s") { should == DateTime.now.to_s }

    it { should allow_mass_assignment_of(:phone_number) }
    it { should allow_mass_assignment_of(:email) }
  end

  context :relations do
    it { should belong_to(:bill) }
  end

  context :validations do
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:bill_id) }
  end

end