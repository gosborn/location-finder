Rails.application.routes.draw do
  get 'profile', action: :show, controller: 'users'
  resources :users, only: %w(show create destroy) do
    collection do
      post 'login'
    end
  end
end
