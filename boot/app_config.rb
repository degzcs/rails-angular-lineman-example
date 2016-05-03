
raw_config = File.read(File.expand_path "#{Rails.root}config/app_config.yml")
APP_CONFIG = YAML.load(ERB.new(raw_config).result)[Rails.env].symbolize_keys
APP_CONFIG[:last_commit_message] = `git log -1 --oneline`
date_time = Rails.root.to_s.split('/').last
APP_CONFIG[:deploy_timestamp] = DateTime.parse(date_time) if Rails.env.staging?