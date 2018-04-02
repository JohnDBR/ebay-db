Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :create] do 
    collection do
      get 'origins', to: 'origins#index'
      get 'origins/:id', to: 'origins#show'
      post 'origins', to: 'origins#create'
      put 'origins/:id', to: 'origins#update'
      delete 'origins/:id', to: 'origins#destroy'
    end
  end 
  
  # get 'users/:id', to: 'users#show' #What the code up do...
  put 'users', to: 'users#update'
  delete 'users', to: 'users#destroy'

  namespace :users do
    put ':user_id/admin', to: 'admins#update'
    delete ':user_id/admin', to: 'admins#destroy'
    get ':user_id/block/admin', to: 'admins#block'
    get ':user_id/deblock/admin', to: 'admins#deblock'
    get 'blocks/admin', to: 'admins#index_block'
  end

  resources :sessions, only: :create
  delete 'sessions', to: 'sessions#destroy' 

  # get 'users/origins', to: 'origins#index'
  # get 'users/origins/:id', to: 'origins#show'
  # post 'users/origins', to: 'origins#create'
  # put 'users/origins/:id', to: 'origins#update'
  # delete 'users/origins/:id', to: 'origins#destroy'

end
