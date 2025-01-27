require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  mount Sidekiq::Web => "/sidekiq"
  resources :rooms
  root "messages#index"
  resources :messages
  post :update_cookie, to: "cookies#update"
  match '*path', to: "application#all", via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
