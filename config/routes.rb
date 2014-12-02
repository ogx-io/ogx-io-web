Rails.application.routes.draw do
  resources :blocked_users

  resources :moderator_applications

  resources :boards do
    collection do
      get :manage
    end

    member do
      get :blocked_users
      post :block_user
    end

    resources :posts, shallow: true do
      member do
        patch :toggle
        patch :resume
      end

      collection do
        get :elites
        get :deleted
      end
    end

    resources :topics, shallow: true do
      collection do
        get :deleted
      end

      member do
        patch :resume
        get :show_post
      end
    end
  end

  concern :approvable do
    member do
      patch :approve
      patch :reject
    end
  end

  resources :board_applications, concerns: :approvable

  root to: 'boards#index'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  resources :users do
    member do
      get :topics
      get :elites
    end
  end
end
