Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :create, :update, :destroy] 
  # get 'users/:id', to: 'users#show' #What the code up do...
  get 'user_seller_score/:id', to: 'users#seller_score'
  get 'user_buyer_score/:id', to: 'users#buyer_score'
  get 'pending_actions', to: 'users#pending_actions'
  namespace :users do
    put ':user_id/block', to: 'admins#block'
    put ':user_id/unblock', to: 'admins#unblock'
    get 'blocks/admin', to: 'admins#index_block'
  end

  resources :sessions, only: :create
  delete 'sessions', to: 'sessions#destroy' 

  resources :origins, only: [:index, :show, :create, :update, :destroy]
  
  resources :products, only: [:index, :show, :create, :update, :destroy] do 
    resources :comments, only: [:index, :create]
    put 'set_purchase_destination/:origin_id', to: 'purchases#set_destination'
    put 'upload_pictures', to: 'pictures#product'
    resources :pictures, only: [:index]
  end
  post 'search', to: 'products#search'
  namespace :products do
    put ':product_id/block', to: 'admins#block'
    put ':product_id/unblock', to: 'admins#unblock'
    get 'blocks/admin', to: 'admins#index_block'
  end

  resources :comments, only: [:show, :destroy]
  get 'user_comments', to: 'comments#user_index'

  resources :purchases, only: [:index, :show, :create]
  get 'user_sales', to: 'purchases#sold_index'
  put 'buyer_score/:id', to: 'purchases#set_buyer_score'
  put 'seller_score/:id', to: 'purchases#set_seller_score'
  put 'purchase_shipped/:id', to: 'purchases#set_was_shipped'
  put 'purchase_delivered/:id', to: 'purchases#set_was_delivered'

  put 'profile_pictures', to: 'pictures#profile'
  put 'product_picture/:product_picture_id/set_cover', to: 'pictures#set_picture_as_cover'
  delete 'product_picture/:product_picture_id', to: 'pictures#destroy'
end
