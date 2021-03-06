Rails.application.routes.draw do


  get 'searches/search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get 'home/about' => 'homes#about'
  get "search" => "searches#search"
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
    collection do
      get 'confirm'
    end
  end

  resources :chats, only: [:show, :create]
  resources :groups, only: [:index, :show, :edit, :create, :update, :new, :show] do
    resource :group_users, only: [:create, :destroy]
    resources :event_notices, only:[:new, :create]
    get "event_notices" => "event_notices#sent"
  end

end
