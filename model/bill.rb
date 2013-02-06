require 'ohm'

class Bill < Ohm::Model
  attribute :issued_by

  def validate
    assert_present :issued_by
  end
end
