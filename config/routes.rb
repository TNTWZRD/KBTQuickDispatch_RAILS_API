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
      put 'users/profile', to: 'users#update_profile'
      put 'users/preferences', to: 'users#update_preferences'
      put 'users/change_password', to: 'users#change_password'

      post 'users/update_roles', to: 'users#update_roles'
      post 'users/update_user', to: 'users#update_user'

      get 'users/getUsers', to: 'users#getUsers'
      
      get 'drivers/getDrivers', to: 'drivers#getDrivers'
      
      # v1-specific routes here
    end
  end


end
