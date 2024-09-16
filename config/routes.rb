Rails.application.routes.draw do
  get "/", to: "login#index"
  get "login", to: "login#index"
  resources :page
end
