# encoding: utf-8

class ReceiptUploader < FileUploader
  def updatemodel file
    model.update_attribute("receipt_filename".to_sym, self.filename )
    model.update_attribute("receipt_url".to_sym, self.url )
  end
end
