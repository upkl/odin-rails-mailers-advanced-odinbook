Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[show index]

  root 'users#show'
end
