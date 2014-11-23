Rails.application.routes.draw do
  resources :moderator_applications

  resources :boards do
    collection do
      get :manage
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

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
