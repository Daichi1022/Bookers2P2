Rails.application.routes.draw do
  
  get 'groups/index'
  get 'groups/show'
  get 'groups/new'
  get 'groups/edit'
  root to: "homes#top"
  get 'home/about' => 'homes#about', as: 'about'
  get "search" => "searches#search"  #検索機能
  devise_for :users
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  #グループ機能
  resources :groups do
    get "join" => "groups#join"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end

end
