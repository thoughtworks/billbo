# encoding: UTF-8

require 'spec_helper'

describe Receipt do

  context :relations do
    it { should belong_to(:bill) }
  end

  context :validations do
    it { should validate_presence_of(:contributor_email) }
  end

end
