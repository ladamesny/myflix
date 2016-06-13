Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: "pages#front"
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: "videos#search"
    end
  end
  resources :reviews, only: [:create]
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"
  resources :users, only: [:index, :create, :show]
  resources :sessions, only: [:create]
end
