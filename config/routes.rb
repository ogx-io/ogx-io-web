Rails.application.routes.draw do
  resources :moderator_applications

  resources :boards do
    collection do
      get :manage
    end
    resources :posts, shallow: true do
      member do
        patch :toggle
      end
      collection do
        get :elites
      end
    end
    resources :topics
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
