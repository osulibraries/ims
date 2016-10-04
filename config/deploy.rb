# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'ims'
set :repo_url, 'git@repo'

# Default branch is master
set :branch, ENV['BRANCH'] || "master"


set :rvm_ruby_version, 'ruby-2.2.0-preview1@ims'

set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/rails/apps/#{fetch(:application)}"

set :tmp_dir, "/home/rails/tmp/#{fetch(:application)}"

set :resque_server_roles, :worker

set :whenever_roles, [:worker]

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# config/browse_everything_providers.yml
set :linked_files, %w{config/analytics.yml  config/database.yml config/devise.yml config/fedora.yml config/redis.yml config/resque-pool.yml config/secrets.yml config/solr.yml config/local_env.yml config/handle_server.yml config/newrelic.yml}

# Default value for linked_dirs is []
# Removed bin
set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# Whats a good route/uri to hit to warm up the site. To ping after deploy.
set :ping_url, "https://localhost:8092/#{fetch(:application)}"


# Deployment Tasks
# ==================
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{release_path.join('tmp')}"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Warm up the application by pinging it'
  task :ping do
    on roles(:app), in: :sequence, wait: 5 do
      execute "curl -s --insecure -D - #{fetch(:ping_url)} -o /dev/null"
    end
  end

  # Deployment Hooks
  after :publishing, :restart
  after :restart, :ping

end
