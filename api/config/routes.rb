Rails.application.routes.draw do
  resources :visits, only: [:index, :show, :create]
  resources :locations, only: [:show]
  get 'profile', action: :show, controller: 'users'
  resources :users, only: %w(show create destroy) do
    collection do
      post 'login'
    end
  end
end
