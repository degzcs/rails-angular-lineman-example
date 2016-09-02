# config valid only for current version of Capistrano
lock '3.6.1'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :application, 'trazoro'
set :repo_url, 'git@bitbucket.org:trazoro-team/trazoro-web.git'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :nodenv_type, :user # or :system, depends on your nodenv setup
set :nodenv_node, File.read('.node-version').strip
set :nodenv_prefix, "NODENV_ROOT=#{fetch(:nodenv_path)} NODENV_VERSION=#{fetch(:nodenv_node)} #{fetch(:nodenv_path)}/bin/nodenv exec"
set :nodenv_map_bins, %w{node npm lineman}
set :nodenv_roles, :all # default value
set :keep_releases, '5'

# set :stages, %w[staging production]
# set :default_stage, 'staging'

# dirs we want symlinked to the shared folder
# during deployment
set :linked_dirs, %w{uploads log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :linked_files, %w{config/database.yml config/app_config.yml config/secrets.yml config/.env frontend/config/application.coffee}

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

namespace :db do
  desc 'run seeds'
  task :run_seeds do
     on roles(:web) do
      within "#{current_path}" do
        execute :rake, 'db:seed RAILS_ENV=staging '
      end
    end
  end
end

# namespace :deploy do
# end
