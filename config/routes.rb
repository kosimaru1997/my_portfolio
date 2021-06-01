Rails.application.routes.draw do
    
  namespace :public do
    get 'posts/index'
    get 'posts/show'
  end
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }
  
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:create, :index, :show, :destroy]
    
  end

end