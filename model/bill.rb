class Bill
  include Mongoid::Document
  field :issued_by, type: String
  field :due_date, type: Date
  field :total_amount, type: Float
  field :barcode, type: String
  field :status, type: Symbol, default: :opened

  def close
    self.status = :closed
    self.save
  end
end
