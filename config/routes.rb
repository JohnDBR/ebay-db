Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :create, :update, :destroy]
  # get 'users/:id', to: 'users#show' #What the code up do...
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
  end

  resources :comments, only: [:show, :destroy]
  get 'user_comments', to: 'comments#user_index'

end
