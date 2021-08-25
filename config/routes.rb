# frozen_string_literal: true

Rails.application.routes.draw do

  # ーーーーーーー管理者ーーーーーーーー
  devise_for :admins, controllers: {
    sessions: 'users/sessions'
  }
  namespace :admin do
    authenticated :admin do
      root to: 'users#top'
    end
    resources :users, only: [:show]
    delete 'user/:id/down' => 'users#down', as: 'user_down'
    post 'user/:id/up' => 'users#up', as: 'user_up'
    resources :posts,  only: %i[index show destroy]
    resources :post_comments, only: %i[index show destroy]
  end
  # ーーーーーーーーーーーーーーーーーー

  # ーーーーーー未ログイン時ーーーーーー
  devise_scope :user do
    unauthenticated :user do
      root to: 'users/registrations#new', as: :unauthenticated_root
    end
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  namespace :unlogin do
    resources :users, only: [:index]
    resources :posts, only: [:index]
  end
  # ーーーーーーーーーーーーーーーーーーー

  # ーーーーーーログイン後ーーーーーー
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  scope module: :public do
    authenticated :user do
      root to: 'homes#top'
    end
    get '/site_top' => 'sites#site_top'
    get '/site/preview' => 'sites#preview'
    get 'users/:id/confirm' => 'users#confirm', as: 'user_confirm'
    resources :rooms, only: %i[create index show]
    resources :users, except: [:new] do
      resource :relationships, only: %i[create destroy]
      resource :chats, only: [:create]
      get :following, on: :member
      get :followers, on: :member
      get :favorites, on: :member
      get :site, on: :member
    end
    resources :posts, except: %i[edit new] do
      resource :favorites, only: %i[create destroy]
      resources :post_comments, only: %i[create destroy show]
      resource :reposts, only: %i[create destroy]

      get :favorited, on: :member
    end
    resources :sites, only: %i[new index show edit create destroy update]
    resources :notifications, only: %i[index destroy]
    delete 'notifications_all' => 'notifications#destroy_all'
  end
  # ーーーーーーーーーーーーーーーーーーー

  # ーーーーお問い合わせーーーー
  get   'inquiry'         => 'inquiry#index'
  post  'inquiry'         => 'inquiry#index'
  post  'inquiry/confirm' => 'inquiry#confirm'
  post  'inquiry/thanks'  => 'inquiry#thanks'
end
