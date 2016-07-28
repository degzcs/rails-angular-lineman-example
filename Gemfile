source 'https://rubygems.org'

ruby "2.3.0"

gem 'rails', '4.1.9'

# PDF
gem 'prawn','1.0.0.rc2'
gem 'pdf-reader', '~> 1.3.3'

# DB
gem 'pg'
gem 'bcrypt'

# Model and active POROs
gem 'active_attr'

gem 'sass-rails', '~> 4.0.3'

gem 'execjs'
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'

gem 'turbolinks'

gem 'jbuilder', '~> 2.0'

gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'spring',        group: :development

gem 'rails-lineman', github: 'degzcs/rails-lineman'

gem 'activeadmin', github: 'activeadmin'
gem 'devise'
gem 'cancancan'
gem 'factory_girl_rails'
gem 'faker'
gem 'sass'
gem 'will_paginate', '~> 3.0.6'
gem 'barby'
gem 'country_select', github: 'stefanpenner/country_select'

# upload files
gem 'fog', require: 'fog/aws'
gem 'carrierwave'
gem 'rmagick'

# API
gem 'jwt'
gem 'httparty'
gem 'rack-contrib', '~> 1.1.0'
gem 'grape', '0.16.2'#github: 'intridea/grape'
gem 'grape-entity', '0.5.0 '
gem 'grape-swagger', '0.20.3'
gem 'grape-swagger-rails', '~> 0.2.2'
#gem "hashie_rails"
gem 'hashie-forbidden_attributes', '~> 0.1.1'
gem 'selenium-webdriver', '~> 2.53'
gem 'virtus'

group :development do
  gem 'quiet_assets'
  gem 'annotate'
  # Capistrano
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-postgresql', '~> 3.0'
  gem 'capistrano-passenger'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'capistrano-nodenv', '~> 1.1.0'
  gem 'guard', '~> 2.14.0'
  gem 'rubocop', '~> 0.42.0', require: false
  gem 'guard-rubocop', '~> 1.2.0'
  gem 'rubycritic', '~> 2.7.0', require: false
  gem 'rails_best_practices', '~> 1.15.7', require: false
  gem 'inch', '~> 0.7.0', require: false
  gem 'guard-inch', '~> 0.2.0'
end

group :development, :test do
  gem 'jazz_hands', github: 'jkrmr/jazz_hands'
  gem 'rspec-rails'
end

group :test do
  #gem 'capybara'
  #gem 'capybara-webkit'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
end

