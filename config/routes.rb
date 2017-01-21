RubyBB::Application.routes.draw do
  root :to => 'forums#index'

  resources :topics, :except => :show do
    member do
      put 'pin' => :pin
    end
  end
  get '/topics/:id.:format' => 'topics#feed', :format => :rss
  get '/topics/:id' => 'topics#show'

  resources :forums, :except => :show do
    collection do
      put 'position' => :position
    end
  end
  get '/forums/:id.:format' => 'forums#feed', :format => :rss
  get '/forums/:id' => 'forums#show'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  as :user do
    get 'register' => 'devise/registrations#new', :as => :new_user_registration
    post 'profile' => 'registrations#create', :as => :user_registration
    delete 'profile' => 'devise/registrations#destroy', :as => :user_registration
    get 'profile' => 'devise/registrations#edit', :as => :edit_user_registration
    put 'profile' => 'registrations#update', :as => :user_registration
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  devise_for :users, :skip => [:sessions, :registrations]

  resources :users, :only => [:index, :show] do
    collection do
      get 'tokens'
      get 'ajax'
    end
    member do
      put 'bot' => :bot
    end
  end

  resources :messages

  resources :small_messages, :only => [:create, :destroy]

  resources :follows, :only => [:index, :create, :destroy]

  resources :notifications, :only => [:index, :destroy] do
    member do
      put '' => :mark_as_read
    end
    collection do
      put '' => :mark_all_as_read
      delete '' => :clear
    end
  end
  resources :bookmarks, :only => :index do
    collection do
      put '' => :mark_all_as_read
      delete '' => :clear
    end
  end

  resources :groups

  get 'check' => 'domains#check'
  get 'admin.:format' => 'domains#css', format: :css, as: :domains
  get 'admin' => 'domains#show', as: :domains
  put 'admin' => 'domains#update'
  delete 'admin/banner' => 'domains#delete_banner', as: :domain_banner

  get '/404', :to => 'errors#not_found'
  get '/422', :to => 'errors#server_error'
  get '/500', :to => 'errors#server_error'

  get '/:id' => 'high_voltage/pages#show', :as => :static

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
