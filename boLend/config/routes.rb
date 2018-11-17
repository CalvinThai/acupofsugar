Rails.application.routes.draw do
  get 'admin/index'
  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/indexx'
  get 'users/new'
  get 'items/index'
  get 'items/show'
  resources :password_resets

  resources :users do
  	resources :items do
      put 'lent_out'
    end
  	resources :on_hold_items do
      put 'update_request_status'
    end
  	resources :wish_lists
    resources :friendships
    resources :borrowed_items
    resources :lend_items
    resources :review_lender_and_items
    resources :review_borrowers
    member do
      get :confirm_email
    end
  end

  resources :items

  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
    Rails.application.routes.draw do
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
end


  #save for later use, redirect user to /profile page rather than /user/:id - by jiehao
  #get 'profile', to: 'users#show'

  resources :conversations do
  resources :messages
 end


end
