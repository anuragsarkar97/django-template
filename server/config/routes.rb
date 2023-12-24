# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :auth do
      post 'sign_in' => 'authentication#sign_in'
      post 'sign_up' => 'authentication#sign_up'
      post 'sign_out' => 'authentication#sign_out'
      post 'verify' => 'authentication#verify'
      post 'forgot_password' => 'authentication#forgot_password'
      post 'reset_password' => 'authentication#reset_password'
      get 'get_user' => 'authentication#get_user'
    end
  end


  # Defines the root path route ("/")
  # root "posts#index"
end
