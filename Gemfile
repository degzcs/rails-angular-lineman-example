source 'https://rubygems.org'

gem 'rails', '4.1.9'

gem 'pg'

gem 'sass-rails', '~> 4.0.3'

gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'

gem 'turbolinks'

gem 'jbuilder', '~> 2.0'

gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'spring',        group: :development

gem 'rails-lineman', github: 'degzcs/rails-lineman'

#heroku
ruby "2.1.3"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  gem 'quiet_assets'

  # Capistrano
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-postgresql', '~> 3.0'
  gem 'capistrano-passenger'
  gem 'capistrano3-nginx', '~> 2.0'
  gem 'capistrano-nodenv', '~> 1.0'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

