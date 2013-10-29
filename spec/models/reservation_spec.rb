# encoding: UTF-8

require 'spec_helper'

describe Reservation do

  its("date.to_i") { should == DateTime.now.to_i }
  its("status") { should == :active }

  describe "formating fields" do
    context :email do
      it { should validate_format_of(:email).to_allow("a@b.com") }
      it { should validate_format_of(:email).not_to_allow("ab.com") }
      it { should validate_format_of(:email).not_to_allow("abER@.com") }
      it { should validate_format_of(:email).not_to_allow("abER@ss..com") }
      it { should validate_format_of(:email).not_to_allow("ab@ss..com") }
    end

    context :phone_number do
      it { should validate_length_of(:phone_number).within(8..10) }
    end

    context :ddd do
      it { should validate_length_of(:ddd).is(2) }
    end
  end

  context :fields do
    it { should allow_mass_assignment_of(:ddd) }
    it { should allow_mass_assignment_of(:phone_number) }
    it { should allow_mass_assignment_of(:email) }

    it { should_not allow_mass_assignment_of(:date) }
    it { should_not allow_mass_assignment_of(:active_until) }
  end

  context :relations do
    it { should belong_to(:bill) }
  end

  context :validations do
    it { should validate_presence_of(:email) }
  end

end
