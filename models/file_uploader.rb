# encoding: UTF-8

class FileUploader < CarrierWave::Uploader::GoogleDrive
  include CarrierWave::RMagick

  google_login ENV['billbo_login']
  google_password ENV['billbo_password']

  def extension_white_list
    %w(pdf)
  end

  def updatemodel(file)
    model.update_attribute(:filename, self.filename)
    model.update_attribute(:url, self.url)
  end
end