class Bill
  attr_reader :id, :issued_by, :due_date, :total_amount, :barcode, :bill_receipt, :status

  def initialize(id, issued_by, due_date, total_amount, barcode, bill_receipt = nil, status = :opened)
   @id            = id.to_i
   @issued_by     = issued_by
   @due_date      = due_date
   @total_amount  = total_amount
   @barcode       = barcode
   @bill_receipt  = bill_receipt
   @status        = status
  end

  def self.find(id)
    bill = REDIS.hgetall("bills:#{id}")
    new id,bill['issued_by'],bill['due_date'],bill['total_amount'],bill['barcode'],bill['bill_receipt'],bill['status']
  end
end
