# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#show'

  resource :fetch_complaints, only: :show
  resources :portfolios do
    resources :buildings
  end
  resources :buildings
  resources :complaints
end
