# config valid only for current version of Capistrano
lock '3.4.0'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :application, 'trazoro'
set :repo_url, 'git@bitbucket.org:trazoroteam/trazoro.git'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :nodenv_type, :user # or :system, depends on your nodenv setup
set :nodenv_node, '0.10.32'
set :nodenv_prefix, "NODENV_ROOT=#{fetch(:nodenv_path)} NODENV_VERSION=#{fetch(:nodenv_node)} #{fetch(:nodenv_path)}/bin/nodenv exec"
set :nodenv_map_bins, %w{node npm lineman}
set :nodenv_roles, :all # default value

# set :stages, %w[staging production]
# set :default_stage, 'staging'

# dirs we want symlinked to the shared folder
# during deployment
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, %w{config/database.yml config/app_config.yml}

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/code/trazoro'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "$HOME/.nodenv/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      #
      # The capistrano-unicorn-nginx gem handles all this
      # for this example
    end

    on roles(fetch(:passenger_roles)), in: fetch(:passenger_restart_runner), wait: fetch(:passenger_restart_wait), limit: fetch(:passenger_restart_limit) do
  		execute :touch, release_path.join('tmp/restart.txt')
	  end
  end

  after :publishing, 'nginx:restart'

  after :restart, :deploy_frontend do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within "#{current_path}/frontend" do
        execute :npm, 'install'
        execute :lineman, "build"
        execute  "mv #{current_path}/frontend/dist/* #{current_path}/public"
      end
    end
  end

end
