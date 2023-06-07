Rails.application.routes.draw do

  namespace :api do
    resources :orders, :orders, only: [:index, :show, :create]
  end
end
