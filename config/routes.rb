Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }
      
      get '/users/doctors/:id', to: 'users#show_doctor'
      resources :users, only: [:index, :show, :destroy]
      resources :appointments, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
