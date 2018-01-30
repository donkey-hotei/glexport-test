Rails.application.routes.draw do
  # API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :shipments
      resources :companies
      resources :products
    end
  end
end
