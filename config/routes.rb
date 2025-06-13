Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'users/confirm_session', to: 'users/sessions#confirm'
  end

  namespace :api do
    namespace :v1 do
      get :status, to: 'base#status'
      # v1-specific routes here
    end
  end


end
