Rails.application.routes.draw do
  get 'admin/index'
  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/index'
  get 'users/new'

  resources :users do
  	resources :items
  	resources :on_hold_items
  	resources :wish_lists
  end
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

end
