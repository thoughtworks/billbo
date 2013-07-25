# encoding: utf-8

class FileUploader < CarrierWave::Uploader::GoogleDrive
    include CarrierWave::RMagick

  process :resize_to_limit => [500, 500]

  google_login 'user'
  google_password 'password'

  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  def updatemodel file
    model.update_attribute("#{self.mounted_as}".to_sym, build_version_hash(self.key).to_yaml)
    model.update_attribute("#{self.mounted_as}_url".to_sym, url)
  end

end
