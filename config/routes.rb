Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'  
  }
  devise_scope :user do
    get 'profiles', to: 'users/registrations#new_profile'
    post 'profiles', to: 'users/registrations#create_profile'
  end

  root "homes#index"

  resources :users, only: [:index,:show]
  resources :products do

    resources :comments, only: [:new, :create, :destroy]

    collection do
      get 'search'
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
      get 'get_size', defaults: { format: 'json' }
    end

    member do 
      get 'purchase'
      post 'pay', to: 'products#pay'
      get 'confirm'
      delete 'image_destroy', defaults: { format: 'json' }
    end

  end

  resources :cards, only: [:new, :index, :show, :destroy] do
    collection do
      post 'pay', to: 'cards#pay'
    end
  end
end  
