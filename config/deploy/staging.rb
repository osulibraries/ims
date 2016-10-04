# Server Roles
# ==================

role :app,    %w{host}
role :web,    %w{host}
role :db,     %w{host}
role :worker, %w{host}


# Rails Environment
# ======================

set :rails_env, 'production'
set :branch, ENV['BRANCH'] || 'staging'

# Deployment Hooks
# ==================

after 'deploy:published', 'resque:pool:full_restart'
