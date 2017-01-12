require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  ## ROOT
  root to: "application#index"

  ## API
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/api_doc'

  ## Sidekiq web interface
  mount Sidekiq::Web, at: "/sidekiq"

end
