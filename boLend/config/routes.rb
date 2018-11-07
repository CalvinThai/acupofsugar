Rails.application.routes.draw do
  get 'admin/index'
  get 'welcome/index'
  root 'items#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/indexx'
  get 'users/new'
  get 'items/index'
  get 'items/show'

  resources :users do
  	resources :items
  	resources :on_hold_items
  	resources :wish_lists
    resources :friendships
    resources :lend_items
    member do
      get :confirm_email
    end
  end

  resources :items

  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end


  #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
  #get 'profile', to: 'users#show'

  resources :conversations do
  resources :messages
 end


end
