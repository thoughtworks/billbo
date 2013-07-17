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

  def total_amount
    sprintf('%.2f', @total_amount)
  end

  def to_s
    "Bill: id:#{@id}, issued_by:#{@issued_by}, due_date:#{@due_date}, total_amount:#{@total_amount}, barcode:#{@barcode}, status:#{@status}"
  end
end
