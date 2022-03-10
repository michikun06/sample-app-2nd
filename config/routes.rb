Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  # GET /users/1/following
  # GET /users/1/followers
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :users
  resources :account_activations, only: [:edit]     # editアクションに関するURLだけ作成
  resources :password_resets,     only: [:new, :create, :edit, :update]     # :new, :create, :edit, :updateアクションに関するURLだけ作成
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end