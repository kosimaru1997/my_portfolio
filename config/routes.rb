Rails.application.routes.draw do
    
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }
  
  scope module: :public do
    root to: 'homes#top'
    get '/about' => 'homes#about'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end

end