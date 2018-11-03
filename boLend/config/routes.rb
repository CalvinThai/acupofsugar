Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/index'

  resources :users do
  	resources :items
  	resources :on_hold_items
  	resources :wish_lists
  end

end
