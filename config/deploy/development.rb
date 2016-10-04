# Server Roles
# ==================

role :app,    %w{host}
role :web,    %w{host}
role :db,     %w(host)


# Rails Environment
# ======================

set :rails_env, 'production'
