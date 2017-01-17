conf_file = File.join('config','s3.yml')
S3 = YAML.load(File.read(conf_file))[Rails.env]

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => S3["aws_access_key_id"],                        # required
    :aws_secret_access_key  => S3["aws_secret_access_key"],                        # required
    :endpoint               => "https://s3.amazonaws.com",
    #:region                 => 'eu-west-1'
    #:path_style => true
  }

  config.fog_directory      = S3["bucket"]                     # required
  config.asset_host         = "https://#{S3['bucket']}.s3.amazonaws.com"
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
