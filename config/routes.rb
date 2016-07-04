Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users


  resources :users
  get 'home/index'
  root :to => 'home#index'
  mount API => '/'



  post 'api/v1/accounts/create'        => 'home#create'
  post 'api/v1/accounts/sign_in'        => 'home#create_session'
  post 'api/v1/accounts/sign_out'       => 'home#delete_session'

  post 'api/v1/accounts/destroy'        => 'home#destroy'

end
