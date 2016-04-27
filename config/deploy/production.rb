# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


role :app, %w{ec2-user@52.9.190.76}
role :web, %w{ec2-user@52.9.190.76}
role :db,  %w{ec2-user@52.9.190.76}
set :branch, 'production'
set :deploy_to, '/home/ec2-user/code/trazoro'


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '52.9.190.76', user: 'ec2-user', roles: %w{web app db}, my_property: :my_value


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
