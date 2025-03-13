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
      resources :inspections
    end
    resources :complaints, only: :index
    resources :violations, only: :index
    resources :inspections, only: :index
    resources :upcoming_inspections, only: %i[index update]
  end

  resources :attachments, only: [:destroy]

  resources :users

  # daily cron jobs
  resource :fetch_complaints, only: :show
  resource :fetch_violations, only: :show
  resource :fetch_inspections, only: :show
end
