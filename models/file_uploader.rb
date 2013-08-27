# encoding: UTF-8

class FileUploader < CarrierWave::Uploader::GoogleDrive
  include CarrierWave::RMagick
  process :resize_to_limit => [1000, 1000]

  google_login ENV['billbo_login']
  google_password ENV['billbo_password']

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def updatemodel(file)
    model.update_attribute(:filename, self.filename)
    model.update_attribute(:url, self.url)
  end
end
