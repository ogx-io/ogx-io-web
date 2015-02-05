Rails.application.routes.draw do

  resources :elite_categories
  resources :categories
  resources :pictures

  namespace :admin do
    resources :posts do
      member do
        patch :resume
      end
    end
    resources :comments do
      member do
        patch :resume
        delete :delete_all
      end
    end
    resources :boards
    resources :users
    resources :nodes do
      member do
        patch :order_up
        patch :order_down
      end
    end
    resources :categories
    resources :blocked_users
    resources :elite_categories
  end

  resources :comments do
    member do
      patch :resume
      delete :delete_all
    end
  end

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
      patch :collect_board
      patch :uncollect_board
    end

    resources :notifications do
      collection do
        delete :clean
      end
    end
  end

  get '/:name', to: 'users#show', as: :show_user
  get '/:name/topics', to: 'users#topics', as: :show_user_topics
  get '/:name/posts', to: 'users#posts', as: :show_user_posts
  get '/:name/elites', to: 'users#elites', as: :show_user_elites
  get '/:name/deleted_posts', to: 'users#deleted_posts', as: :show_user_deleted_posts
  get '/t/:sid', to: 'topics#show', as: :show_topic
  get '/p/:sid', to: 'posts#show', as: :show_post
  get '/t/:topic_sid/p/:post_sid', to: 'topics#show_post', as: :show_topic_post
  get '/t/:sid/f/:floor', to: 'topics#show_post', as: :show_topic_floor

end
