# encoding: utf-8

class FileUploader < CarrierWave::Uploader::GoogleDrive
  include CarrierWave::RMagick
  process :resize_to_limit => [500, 500]
  after :store, :cleanup

  google_login ENV['login']
  google_password ENV['password']

  def extension_white_list
    %w(jpg jpeg gif png pdf)
  end

  def updatemodel file
    if ENV['RACK_ENV'] != 'test'
      model.update_attribute("#{self.mounted_as}".to_sym, build_version_hash(self.key).to_yaml)
      model.update_attribute("#{self.mounted_as}_url".to_sym, url)
    end
  end
  
  def cleanup file
    if ENV['RACK_ENV'] == 'test'
      FileUtils.rm_rf(Dir[File.join(File.dirname(__FILE__), "../public/#{store_dir}/[^.]*")])
    end
  end
end
