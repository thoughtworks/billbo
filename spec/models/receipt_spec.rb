# encoding: UTF-8

require 'spec_helper'

describe Receipt do

  context :relations do
    it { should belong_to(:bill) }
  end

  context :validations do
    it { should validate_presence_of(:contributor_email) }
  end

  describe "formating fields" do
    context :contributor_email do
      it { should validate_format_of(:contributor_email).to_allow("a@b.com") }
      it { should validate_format_of(:contributor_email).not_to_allow("ab.com") }
      it { should validate_format_of(:contributor_email).not_to_allow("abER@.com") }
      it { should validate_format_of(:contributor_email).not_to_allow("abER@ss..com") }
      it { should validate_format_of(:contributor_email).not_to_allow("ab@ss..com") }
    end
  end

end
