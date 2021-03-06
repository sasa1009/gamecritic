Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get    '/guest_login', to: 'sessions#guest_login'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, except: [:new, :create] do
    member do
      get 'recruitment'
      get 'delete_account'
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :games, except: [:index] do
    member do
      get 'recruitments'
    end
  end
  resources :reviews, except: [:index]
  resources :recruitments, except: [:index]
end
