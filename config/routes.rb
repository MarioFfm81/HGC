Rails.application.routes.draw do
  get '/home' => 'posts#index'
  get '/posts/new' => 'posts#new', as: :new_post_path
  post '/posts' => 'posts#create'
  delete '/posts/:id' => 'posts#destroy'
  get '/signup' => 'users#new'
  get '/user/new' => 'users#new'
  post '/user' => 'users#create', as: :user
  post '/user' => 'users#create', as: :users
  patch '/user' => 'users#update'
  get '/user/edit' => 'users#show'
  get 'tippen' => 'tipps#index'
  get '/tippen/:id' => 'tipps#show', as: :tipps
  post '/tippen/:id' => 'tipps#create', as: :new_tipps
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get '/admin' => 'admins#show'
  get '/admin/:id' => 'admins#update'
  resources :overviews
  
  
  get '/' => 'posts#index'
end
