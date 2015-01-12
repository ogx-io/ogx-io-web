::CarrierWave.configure do |config|
  config.storage              = :qiniu
  config.qiniu_access_key     = Rails.application.secrets.qiniu_access_key
  config.qiniu_secret_key     = Rails.application.secrets.qiniu_secret_key
  config.qiniu_bucket         = Rails.application.secrets.qiniu_bucket
  config.qiniu_bucket_domain  = Rails.application.secrets.qiniu_bucket_domain
  # config.qiniu_bucket_private = true #default is false
  config.qiniu_block_size     = 4*1024*1024
  config.qiniu_protocol       = Rails.application.secrets.qiniu_protocol

  config.qiniu_up_host       = 'http://up.qiniug.com'
end