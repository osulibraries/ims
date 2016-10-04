require 'resque/server'

Rails.application.routes.draw do

  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do

    resque_contraint = lambda do |request|
      request.env['warden'].authenticate? && request.env['warden'].user.admin?
    end
    constraints resque_contraint do
      mount Resque::Server.new, at: "/resque"
    end

    blacklight_for :catalog
    # devise_for :users
    Hydra::BatchEdit.add_routes(self)
    mount Riiif::Engine => '/image-service'
    # get "/roles" => 'roles#index'
    # get "/roles/:id" => 'roles#show'
    # get "/roles/:id/edit" => 'roles#edit'
    resources :roles
    post '/roles/add_user/:id', controller: 'roles', action: :add_user, as: 'role_users'
    delete '/roles/remove_user/:id', controller: 'roles', action: :remove_user, as: 'remove_role_users'

    devise_for :users, controllers: { sessions: "devise/shibboleth_sessions" }

    devise_scope :user do
      get 'auth', to: 'devise/shibboleth_sessions#auth', as: :shib_auth
    end

    namespace :osul do
      resources :groups do
        member do
          put 'update_users'
        end
      end
      
      namespace :export do
        resources :export_generic_file_items, only: [:index]
        resources :change_trackers, only: [:index]
      end
    end

    resources :hydra_admin_collections, controller: 'hydra/admin/collections'
    post '/admin_sets/add_members/:id', controller: 'hydra/admin/collections', action: :add_members, as: 'admin_set_add_members'
    get '/admin_sets/get_admin_set_permissions/:id', controller: 'hydra/admin/collections', action: :get_admin_set_permissions
    get 'calculate_admin_set_stats/:id', controller: 'hydra/admin/collections', action: :calculate_admin_set_stats


    resources :trashed_items
    post 'bulk_trash_items', controller: :trashed_items

    scope :dashboard do
      get '/admin_sets', controller: 'my/admin_sets', action: :index, as: 'dashboard_admin_sets'
      get '/admin_sets/page/:page', controller: 'my/admin_sets', action: :index
      get '/admin_sets/facet/:id', controller: 'my/admin_sets', action: :facet, as: 'dashboard_admin_sets_facet'
    end

    resources :import_field_mappings
    resources :imports do
      member do
        post 'start'
        post 'undo'
        post 'resume'
        post 'finalize'
        get 'report'
        get 'image_preview/:row', controller: 'imports', action: :image_preview, as: 'image_preview'
        get 'row-preview/:row_num', controller: 'imports', action: :row_preview, as: 'row_preview'
      end

      collection do
        post 'browse'
      end
    end

    get 'autocomplete/:field', controller: 'osul/autosuggest_date', action: :index

    #Custom generic file routes
    post 'files/:id/characterize', to: 'generic_files#characterize', as: 'generic_file_characterize'

    # This must be the very last route in the file because it has a catch-all route for 404 errors.
      # This behavior seems to show up only in production mode.
      mount Sufia::Engine => '/'
    root to: 'homepage#index'
  end
end
