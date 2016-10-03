Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  get 'my_queue',      to: "queue_items#index"
  get 'register',      to: "users#new"
  get 'sign_in',       to: "sessions#new"
  get 'sign_out',      to: "sessions#destroy"
  get 'people',        to: "relationships#index"
  post "update_queue", to: "queue_items#update_queue"
  post 'follow',       to: "relationships#create"

  resources :relationships, only: [:index, :destroy]
  resources :users,         only: [:index, :create, :show]
  resources :queue_items,   only: [:create, :destroy]
  resources :sessions,      only: [:create]
end
