Rails.application.routes.draw do

  mount ActionCable.server => '/cable'
  
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

      get 'users/getUsers', to: 'users#getUsers'
      post 'users/update_roles', to: 'users#update_roles'
      put 'users/update_user/:id', to: 'users#update_user'
      delete 'users/delete_user/:id', to: 'users#delete_user'

      get 'drivers/getDrivers', to: 'drivers#getDrivers'
      post 'drivers/create_driver', to: 'drivers#create_driver'
      put 'drivers/update_driver/:id', to: 'drivers#update_driver'
      delete 'drivers/delete_driver/:id', to: 'drivers#delete_driver'

      get 'vehicles/getVehicles', to: 'vehicles#getVehicles'
      post 'vehicles/create_vehicle', to: 'vehicles#create_vehicle'
      put 'vehicles/update_vehicle/:id', to: 'vehicles#update_vehicle'
      delete 'vehicles/delete_vehicle/:id', to: 'vehicles#delete_vehicle'
      
      # v1-specific routes here
    end
  end


end
