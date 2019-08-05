Rails.application.routes.draw do
  use_doorkeeper
  mount Doorkeeper::SSO::Engine => "/doorkeeper-sso"

  get :sign_in, to: 'user_sessions#new'
  post :sign_in, to: 'user_sessions#create'
  get :sign_out, to: 'user_sessions#destroy'
end
