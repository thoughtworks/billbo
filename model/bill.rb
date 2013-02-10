class Bill
  attr_reader :id, :issued_by, :due_date, :total_amount, :barcode, :bill_receipt, :status

  def initialize(id, issued_by, due_date, total_amount, barcode, bill_receipt, status)
    @id            = id.to_i
    @issued_by     = issued_by
    @due_date      = due_date
    @total_amount  = total_amount.to_f
    @barcode       = barcode
    @bill_receipt  = bill_receipt
    @status        = status.to_sym
  end

  def self.create(bill)
    REDIS.hmset("bills:#{bill.id}",
                :issued_by, bill.issued_by,
                  :due_date, bill.due_date,
                  :total_amount, bill.total_amount,
                  :barcode, bill.barcode,
                  :bill_receipt, bill.bill_receipt,
                  :status, bill.status)
  end

  def self.count
    REDIS.keys("bills:*").count
  end

  def ===(other_bill)
    self.instance_variables.each do |ivar|
      return unless self.instance_variable_get(ivar).eql? other_bill.instance_variable_get(ivar)
    end
  end
end
