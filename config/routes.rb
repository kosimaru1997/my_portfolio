Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }
  
  
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    get 'chats/index' => 'chats#index', as: 'chats'
    resources :users, except: [:new] do
      resource :relationships, only: [:create, :destroy]
      resource :chats, only: [:show, :create]
      get :following, on: :member
      get :followers, on: :member
      get :favorites, on: :member
    end
    resources :posts, except: [:edit, :new] do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
      get :favorited, on: :member
    end
    resources :notifications, only: :index
  end

end