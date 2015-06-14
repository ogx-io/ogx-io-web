Rails.application.routes.draw do

  root to: 'visitors#index'
  get 'merged_prs', to: 'visitors#merged_prs'
  get 'about', to: 'visitors#about'

  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :likes
  resources :favorites
  resources :categories
  resources :pictures

  namespace :admin do
    get 'site_info/edit'
    put 'site_info/update'

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

    namespace :elite do
      resources :categories
      resources :posts
      resources :nodes do
        member do
          patch :resume
          patch :order_up
          patch :order_down
        end
      end
    end
  end

  namespace :elite do
    resources :categories
    resources :posts do
      member do
        patch :resume
      end
    end
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
      patch :favor
      patch :disfavor
    end

    resources :posts, shallow: true do
      member do
        patch :set_elite
        patch :unset_elite
        patch :top_up
        patch :top_clear
        patch :resume
        get :comments
        patch :like
        patch :dislike
      end
    end

    resources :topics, shallow: true do
      member do
        patch :resume
        patch :toggle_lock
        get :show_post
        get :change_board
      end
    end
  end


  resources :users do
    member do
      get :topics
      get :posts
      get :elites
      get :edit_info
      get :edit_avatar
      get :edit_accounts
      get :edit_self_intro
      patch :update_self_intro
      patch :unbind_account
    end

    resources :notifications, shallow: true do
      collection do
        delete :clean
      end
    end
  end

  get '/@:name', to: 'users#show', as: :show_user
  get '/@:name/topics', to: 'users#topics', as: :show_user_topics
  get '/@:name/posts', to: 'users#posts', as: :show_user_posts
  get '/@:name/elites', to: 'users#elites', as: :show_user_elites
  get '/@:name/deleted_posts', to: 'users#deleted_posts', as: :show_user_deleted_posts
  get '/t/:sid', to: 'topics#show', as: :show_topic
  get '/p/:sid', to: 'posts#show', as: :show_post
  get '/t/:id/p/:post_id', to: 'topics#show_post', as: :show_topic_post
  get '/t/:id/f/:floor', to: 'topics#show_post', as: :show_topic_floor

  get '/*node_path', to: 'nodes#show', constraints: { node_path: /(?!rails\/mailers).*/ }
end
