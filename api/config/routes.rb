require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    resources :visits, only: [:index, :show, :create]
    resources :locations, only: [:show]
    get 'profile', action: :show, controller: 'users'
    resources :users, only: %w(show create destroy) do
      collection do
        post 'login'
      end
    end
  end
end
