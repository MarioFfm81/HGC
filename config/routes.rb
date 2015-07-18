Rails.application.routes.draw do
  get '/home' => 'posts#index'
  get '/posts/new' => 'posts#new', as: :new_post_path
  post '/posts' => 'posts#create'
  delete '/posts/:id' => 'posts#destroy'
  get '/signup' => 'users#new'
  resource :users
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  resource :games
  resources :overviews
  
  
  get '/' => 'posts#index'
end
