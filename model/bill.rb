class Bill
  attr_reader :id, :issued_by, :due_date, :total_amount, :barcode, :receipt, :status

  def initialize(id, issued_by, due_date, total_amount, barcode, receipt, status)
    @id            = id.to_i
    @issued_by     = issued_by
    @due_date      = due_date
    @total_amount  = total_amount.to_f
    @barcode       = barcode
    @receipt       = receipt
    @status        = status.to_sym
  end

  def save
    url = if @receipt
            @receipt.url
          else
            ""
          end
    REDIS.hmset("bills:#{@id}",
                :issued_by, @issued_by,
                  :due_date, @due_date,
                  :total_amount, @total_amount,
                  :barcode, @barcode,
                  :receipt, url,
                  :status, @status)
    REDIS.zadd 'bills', Time.now.to_i, @id
  end

  def self.find(id)
    bill = REDIS.hgetall("bills:#{id}")
    if bill['receipt'] && !bill['receipt'].empty?
      receipt = FileUploader.new
      receipt = bill['receipt']
    else
      receipt = nil
    end
    new id,
      bill['issued_by'],
      bill['due_date'],
      bill['total_amount'],
      bill['barcode'],
      receipt,
      bill['status'] unless bill.empty?
  end

  def self.create(bill)
    id = REDIS.incr("ids:bills")
    b = build(id, bill)
    return b if b.save
  end

  def self.all
    REDIS.zrevrange('bills', 0, -1).map { |id| find id }
  end

  def self.count
    REDIS.keys("bills:*").count
  end

  def to_s
    "Bill: id:#{@id}, issued_by:#{@issued_by}, due_date:#{@due_date}, total_amount:#{@total_amount}, barcode:#{@barcode}, receipt:#{@receipt}, status:#{@status}"
  end

  def ===(other_bill)
    self.instance_variables.each do |ivar|
      return false unless self.instance_variable_get(ivar).eql? other_bill.instance_variable_get(ivar)
    end
  end

  private
  def self.build(id, bill)
    new id, bill.issued_by, bill.due_date, bill.total_amount, bill.barcode, bill.receipt, bill.status
  end
end
