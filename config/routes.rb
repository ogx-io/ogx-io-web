Rails.application.routes.draw do
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
    end
  end

  get '/:path', to: 'topics#index', as: :show_board
  get '/:path/posts', to: 'posts#index', as: :list_board_posts
  get '/:path/elites', to: 'posts#elites', as: :list_board_elites
  get '/u/:name', to: 'users#show', as: :show_user
  get '/u/:name/topics', to: 'users#topics', as: :show_user_topics
  get '/u/:name/posts', to: 'users#show', as: :show_user_posts
  get '/u/:name/elites', to: 'users#elites', as: :show_user_elites
  get '/t/:sid', to: 'topics#show', as: :show_topic
  get '/p/:sid', to: 'posts#show', as: :show_post

end
