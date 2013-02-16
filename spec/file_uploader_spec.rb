require 'spec_helper'

describe FileUploader do
  it 'saves a file on Google Drive' do
    uploader = FileUploader.new
    uploader.store!('http://upload.wikimedia.org/wikipedia/commons/b/b5/Choc-Ola_Cow_Mascot.jpg')
  end
end
