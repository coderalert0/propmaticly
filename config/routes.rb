# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#show'

  resource :fetch_complaints, only: :show
  resource :fetch_violations, only: :show
  resources :portfolios do
    resources :complaints
    resources :violations
  end
  resources :portfolios do
    resources :buildings do
      resources :complaints
      resources :violations
    end
  end
  resources :buildings do
    resources :complaints
    resources :violations
  end
  resources :complaints
  resources :violations
  resources :users
end
