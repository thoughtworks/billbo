require 'spec_helper'

describe Reservation do

  its("date.to_i") { should == DateTime.now.to_i }
  its("active_until.to_i") { should == 24.hours.from_now.to_i }

  context :fields do
    it { should allow_mass_assignment_of(:phone_number) }
    it { should allow_mass_assignment_of(:email) }

    it { should_not allow_mass_assignment_of(:date) }
    it { should_not allow_mass_assignment_of(:active_until) }
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