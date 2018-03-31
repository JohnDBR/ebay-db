Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show, :create]
  # get 'users/:id', to: 'users#show' #What the code up do...
  put 'users', to: 'users#update'
  delete 'users', to: 'users#destroy'

  namespace :users do
    put ':user_id/admin', to: 'admins#update'
    delete ':user_id/admin', to: 'admins#destroy'
    get ':user_id/block/admin', to: 'admins#block'
    get ':user_id/deblock/admin', to: 'admins#deblock'
  end

  resources :sessions, only: :create
  delete 'sessions', to: 'sessions#destroy'
end
