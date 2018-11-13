Rails.application.routes.draw do
  resources :users, only: [:new, :create, :index]
  root to: 'users#new'
end
