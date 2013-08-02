require 'spec_helper'

describe Admin do
  before do
    @admin = Admin.new
  end

  it "validates if email exists on the database" do
    EMAIL_TEST = "test@test.com"

    @admin.exists?(EMAIL_TEST).should be_false
    Admin.create!(:email => EMAIL_TEST)
    @admin.exists?(EMAIL_TEST).should be_true
  end

end
