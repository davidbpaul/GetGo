Rails.application.routes.draw do
  root to: 'welcome#index'

  get 'welcome/index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  # get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/visitor' => 'visitor#index'
end
