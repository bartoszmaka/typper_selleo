Rails.application.routes.draw do
  root to: 'football_matches#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
