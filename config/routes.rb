# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[show index]

  resources :friend_requests, only: %i[create update destroy]

  root 'users#show'
end
