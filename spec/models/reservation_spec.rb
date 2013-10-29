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
      it { should validate_format_of(:phone_number).to_allow("55 (81) 30342-5612") }
      it { should validate_format_of(:phone_number).to_allow("(81) 88555-5522") }
      it { should validate_format_of(:phone_number).to_allow("(81) 32155-522") }
      it { should validate_format_of(:phone_number).to_allow("55 (81) 30342-5621") }
      it { should validate_format_of(:phone_number).not_to_allow("8199887711") }
      it { should validate_format_of(:phone_number).not_to_allow("(81) s8aa5-5522") }
      it { should validate_format_of(:phone_number).not_to_allow("2316418374651308465013465") }
    end
  end

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
    it { should validate_presence_of(:email) }
  end

end
