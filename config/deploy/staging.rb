# require 'capistrano/passenger'
# require 'capistrano/nginx'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


role :app, %w{deploy@trazoro-staging.cloudapp.net}
role :web, %w{deploy@trazoro-staging.cloudapp.net}
role :db,  %w{deploy@trazoro-staging.cloudapp.net}
set :branch, 'staging'


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'trazoro-staging.cloudapp.net', user: 'deploy', roles: %w{web app db}, my_property: :my_value



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

    after :restart, :deploy_frontend do

      on roles(:web), in: :groups, limit: 3, wait: 10 do
        puts 'test'
        # Here we can do anything such as:
        within "#{current_path}/frontend" do
          execute :npm, 'install'
          execute :lineman, "build"
          execute  "mv #{current_path}/frontend/dist/* #{current_path}/public"
      end
    end

  end

  after :publishing, 'nginx:restart'
end