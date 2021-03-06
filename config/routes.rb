Rails.application.routes.draw do
  root to: 'football_matches#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :football_matches, only: :index do
    resources :bets, only: %i[new edit create update destroy], controller: 'football_matches/bets'
  end
  resources :scoreboards, only: :index
  resources :football_matches, only: :create
end
