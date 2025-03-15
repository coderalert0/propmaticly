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

  resources :portfolios do
    resources :complaints, only: :index
    resources :violations, only: :index
  end
  resources :portfolios do
    resources :buildings
  end
  resources :buildings do
    resources :inspection_rules, only: :index do
      resources :inspections, only: :index
    end
    resources :complaints, only: %i[index update]
    resources :violations, only: %i[index update]
    resources :inspections, only: %i[index]
    resources :upcoming_inspections, only: %i[index update]
  end

  resources :inspections, only: %i[create]
  resources :attachments, only: [:destroy]
  resources :users
end
