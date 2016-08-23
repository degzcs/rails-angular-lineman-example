# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'faker'
require 'active_attr/rspec'
# require 'sidekiq/testing'
require 'shoulda/matchers'
require 'carrierwave/test/matchers'
require 'cancan/matchers'

# include seeds
require "#{Rails.root}/db/seeds.rb"

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Configure Capybara and you can pass a debug option set up as true => see documentation
Capybara.configure do |config|
  config.default_host = 'http://127.0.0.1'
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
  end
end
#
# Capybara works with rack_test by default_driver and selenium for javascript_driver
#
# Capybara.register_driver :rack_test do |app|
#   Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Capybara' })
# end

# include seeds
# require "#{Rails.root}/db/test_seeds.rb"

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # #add job_lab_mandrill classes
  # Dir[Rails.root.join('app/job_lab_mandrill/*.rb')].each { |f| require f }
  # Dir[Rails.root.join('app/job_lab_mandrill/**/*.rb')].each { |f| require f }

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Database Cleaner config

  static_info_tables = %w(cities states countries roles settings admin_users)

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, {except: static_info_tables}
  end

  config.before(:context) do
    DatabaseCleaner.clean_with :truncation, {except: static_info_tables}
  end


  config.before :each do |example|
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, { except: static_info_tables }
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean!
    `rm -rf #{Rails.root}/tmp/purchases`
    `rm -rf #{Rails.root}/tmp/sales`
    `rm -rf #{Rails.root}/tmp/purchase_files_collection`
    `rm -rf #{Rails.root}/public/test`
  end

  # Factory Girl methods
  config.include FactoryGirl::Syntax::Methods

  # Include devise test helpers in controller specs
  # config.include Devise::TestHelpers, :type => :controller

  # Capybara
  config.include Capybara::DSL

  # CarrierWave
  config. include CarrierWave::Test::Matchers

  # API
  config.include RSpec::Rails::RequestExampleGroup, parent_example_group: { file_path: %r{spec\/api} }

  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model

  # Include warden helper for use login_as capybara
  config.include Warden::Test::Helpers
  config.before :suite do
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
end
