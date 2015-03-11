Rails.application.routes.draw do

  ## ROOT
  root to: "application#index"

  ## API
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/api_doc'

end
