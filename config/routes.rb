Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: 'users/sessions',
  }

  namespace :admin do
    authenticated :admin do
      root to: 'users#top'
    end
    resources :users, only: [:show]
    delete 'user/:id/down' => 'users#down', as: 'user_down'
    post 'user/:id/up' => 'users#up', as: 'user_up'
    resources :posts,  only: [:index, :show, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }

  #未ログイン時のルート
   devise_scope :user do
      unauthenticated :user do
        root :to => 'users/registrations#new', as: :unauthenticated_root
      end
    end

  scope module: :public do
    authenticated :user do
      root to: 'homes#top'
    end
    get 'chats/index' => 'chats#index', as: 'chats'
    get 'users/:id/confirm' => 'users#confirm', as: 'user_confirm'
    resources :users, except: [:new] do
      resource :relationships, only: [:create, :destroy]
      resource :chats, only: [:show, :create]
      get :following, on: :member
      get :followers, on: :member
      get :favorites, on: :member
    end
    resources :posts, except: [:edit, :new] do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy, :show] #showはAjaxによりリプライ一覧を表示するために使用
      get :favorited, on: :member
    end
    resources :notifications, only: [:index, :destroy]
    delete 'notifications_all' => 'notifications#destroy_all'
  end

  get   'inquiry'         => 'inquiry#index'
  post  'inquiry'         => 'inquiry#index'
  post  'inquiry/confirm' => 'inquiry#confirm'
  post  'inquiry/thanks'  => 'inquiry#thanks'

end