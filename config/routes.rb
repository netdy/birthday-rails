Rails.application.routes.draw do
  get "login", to: "login#index"
  resources :page
end
