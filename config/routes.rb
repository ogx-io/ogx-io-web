Rails.application.routes.draw do

  resources :pictures

  namespace :admin do
    resources :blocked_users
  end

  namespace :admin do
    resources :posts do
      member do
        patch :resume
      end
    end
  end

  namespace :admin do
    resources :comments do
      member do
        patch :resume
        delete :delete_all
      end
    end
  end

  resources :comments do
    member do
      patch :resume
      delete :delete_all
    end
  end

  resources :blocked_users

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
        get :comments
      end

      collection do
        get :elites
      end
    end

    resources :topics, shallow: true do
      member do
        patch :resume
        patch :toggle_lock
        get :show_post
      end
    end
  end

  root to: 'visitors#index'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  resources :users do
    member do
      get :topics
      get :elites
      get :deleted_posts
    end

    resources :notifications do
      collection do
        delete :clean
      end
    end
  end

  get '/:path', to: 'topics#index', as: :show_board
  get '/:path/posts', to: 'posts#index', as: :list_board_posts
  get '/:path/elites', to: 'posts#elites', as: :list_board_elites
  get '/u/:name', to: 'users#show', as: :show_user
  get '/u/:name/topics', to: 'users#topics', as: :show_user_topics
  get '/u/:name/posts', to: 'users#posts', as: :show_user_posts
  get '/u/:name/elites', to: 'users#elites', as: :show_user_elites
  get '/u/:name/deleted_posts', to: 'users#deleted_posts', as: :show_user_deleted_posts
  get '/t/:sid', to: 'topics#show', as: :show_topic
  get '/p/:sid', to: 'posts#show', as: :show_post

end
