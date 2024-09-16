Rails.application.routes.draw do
  get "/", to: "login#index"
  get "login", to: "login#index"
  post "login", to: "login#create"
  delete "login", to: "login#destroy"
  get "register", to: "users#new"
  post "register", to: "users#create"
  resources :page
end
