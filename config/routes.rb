Rails.application.routes.draw do
  resources :visitors
  root to: 'welcome#index'

  get 'welcome/index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

#register
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  # get '/signup' => 'users#new'
end
