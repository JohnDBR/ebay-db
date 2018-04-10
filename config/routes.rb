Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :create, :update, :destroy]
  # get 'users/:id', to: 'users#show' #What the code up do...
  get 'user_seller_score', to: 'users#seller_score'
  get 'user_buyer_score', to: 'users#buyer_score'
  namespace :users do
    get ':user_id/block', to: 'admins#block'
    get ':user_id/unblock', to: 'admins#unblock'
    get 'blocks/admin', to: 'admins#index_block'
  end

  resources :sessions, only: :create
  delete 'sessions', to: 'sessions#destroy' 

  resources :origins, only: [:index, :show, :create, :update, :destroy]
  
  resources :products, only: [:index, :show, :create, :update, :destroy] do 
    resources :comments, only: [:index, :create]
    resources :bids, only: [:index, :create]
    resources :purchases, only: [:create]
  end

  resources :comments, only: [:show, :destroy]
  get 'user_comments', to: 'comments#user_index'

  resources :bids, only: [:show]
  get 'user_bids', to: 'bids#user_index'

  resources :purchases, only: [:index, :show]
  get 'user_sales', to: 'purchases#sold_index'
  post 'buyer_score', to: 'purchases#set_buyer_score'
  post 'seller_score', to: 'purchases#set_seller_score'
  post 'purchase_shipped', to: 'purchases#set_was_shipped'
  post 'purchase_delivered', to: 'purchases#set_was_delivered'

end
