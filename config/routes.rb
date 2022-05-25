Rails.application.routes.draw do
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  resources :posts, only: [:index, :create, :destroy]
  resources :posts do
    member do
      get :retweet  
      delete :destroy_retweet
    end 
  end
  resources :comments, only: [:index, :create, :destroy]
  root to: "static#home"
end