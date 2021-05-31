Rails.application.routes.draw do
  
  root to: 'home#top'
  get '/about' => 'home#about'
  
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }
  
end