require 'rails/all'
require 'carrierwave'
require File.expand_path('boot/app_config.rb')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trazoro
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.rails_lineman.lineman_project_location = "frontend"
    config.rails_lineman.deployment_method = :copy_files_to_public_folder

    # Grape
    # Auto-load API and its subdirectories
    config.paths.add File.join('app', 'api'), :glob => File.join('**', '*.rb')
    config.autoload_paths = Dir[File.join(Rails.root, 'app', 'api', '*')]

    # Concerns
    config.paths.add File.join('lib', 'concerns'), :glob => File.join('**', '*.rb')
    Dir[File.join(Rails.root, 'lib', 'concerns', '*')].each do |file|
        config.autoload_paths << file
    end
    Dir[Rails.root.join('lib/concerns/**/*.rb')].each { |f| require f }
    
    # Rucom Scraper
    config.paths.add File.join('lib', 'rucom_services'), :glob => File.join('**', '*.rb')
    Dir[Rails.root.join('lib/rucom_services/**/*.rb')].each { |f| require f }
    Dir[File.join(Rails.root, 'lib', 'rucom_services', '**/*')].each do |file|
       config.autoload_paths << file
   end
  end
end

