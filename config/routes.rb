Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }

      resources :users, only: [:index, :show, :destroy]
      resources :appointments, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
