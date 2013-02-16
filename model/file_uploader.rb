class FileUploader < CarrierWave::Uploader::GoogleDrive

  google_login 'billboapp@gmail.com'
  google_password '1234baggins'

end
