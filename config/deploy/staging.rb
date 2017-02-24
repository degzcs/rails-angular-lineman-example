# require 'capistrano/passenger'
# require 'capistrano/nginx'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


role :app, %w{ec2-user@52.52.102.85}
role :web, %w{ec2-user@52.52.102.85}
role :db,  %w{ec2-user@52.52.102.85}
set :branch, 'staging'
set :deploy_to, '/home/ec2-user/code/trazoro'

set :ssh_options, {
  user: "ec2-user",
  keys: %w(~/.ssh/trazpro-key-pair-uswest-calfornia.pem),
  forward_agent: false,
}



# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '52.52.102.85', user: 'ec2-user', roles: %w{web app db}


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc ' Restart frontend (pending)'
  task :frontend do
    on roles(:web) do
      # Here we can do anything such as:
      within "#{current_path}/frontend" do
        execute :npm, "install"
        execute :bundle, "install"
        execute :lineman, "build"
        execute "rm -rf #{current_path}/public/css #{current_path}/public/js #{current_path}/public/img #{current_path}/public/fonts"
        execute  "mv -f #{current_path}/frontend/dist/* #{current_path}/public"
      end
    end
  end

  task :add_default_hooks do
    after 'deploy:starting', 'sidekiq:quiet'
    after 'deploy:updated', 'sidekiq:stop'
    after 'deploy:reverted', 'sidekiq:stop'
    after 'deploy:published', 'sidekiq:start'
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
