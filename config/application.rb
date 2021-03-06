require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'carrierwave/orm/activerecord'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsAngularLinemanExample
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
  end
end
