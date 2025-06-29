Rails.application.routes.draw do
  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, 
  controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  get 'current_user', to: 'current_user#index'

  namespace :api do
    namespace :v1 do
      get :status, to: 'base#status'
      
      # User profile management routes
      resources :users do
        put 'profile', to: 'users#update_profile'
        put 'preferences', to: 'users#update_preferences'
        put 'change_password', to: 'users#change_password'
      end
      
      resources :drivers do
        get 'getDrivers', to: 'drivers#getDrivers'
      end
      # v1-specific routes here
    end
  end


end
