# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: %i[show index edit update]

  resources :friend_requests, only: %i[create update destroy]

  resources :posts do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create new edit update destroy]
  end

  root 'users#show'
end
