source 'https://rubygems.org'
gem 'nokogiri', '1.6.5'
gem 'rails', '4.2.1'
gem "therubyracer"
gem "mongoid", "~> 4.0.0"
gem "mongoid-enum"
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'pundit'
gem 'kaminari'
gem 'simple_form'

gem 'devise'
gem 'omniauth-github'

gem 'puma'
gem 'social-share-button', git: 'https://github.com/cuterxy/social-share-button.git'
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'qiniu-rs'
gem 'carrierwave-qiniu', git: 'https://github.com/huobazi/carrierwave-qiniu.git'

gem 'rails_autolink'
gem 'redcarpet'
gem 'rouge'
gem 'md_emoji'
gem "non-stupid-digest-assets"

group :development do
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'

  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'quiet_assets'
  gem 'rails_layout'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'byebug'
end
group :test do
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'faker'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-html-matchers'
  gem 'mongoid-rspec'
end

group :production do
  gem 'newrelic_rpm'
  gem 'newrelic_moped'
end
