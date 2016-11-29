Rails.application.routes.draw do
  root to: 'welcome#index'

  get 'welcome/index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  # get '/signup' => 'users#new'
  # post '/users' => 'users#create'

  resources :users, only: [:new, :create] do
    resource :preference
  end

  # resources :preferences
  resources :schedules, only: :index
  get 'departure/index'
  post 'departure/index'
  post 'departure/getUserDateAndRoute'
  post 'departure/getRouteVariant'
  post 'departure/getFromToStops'
end
