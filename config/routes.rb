Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  mount RailsAdmin::Engine => '/mngmnt', :as => 'rails_admin'
  mount API => "/"

  ## Devise routing

  devise_for :users,  controllers: {registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks", passwords: "users/passwords" }
  devise_for :organizers, controllers: {registrations: "organizers/registrations"}
  devise_for :admins

  # devise_scope :organizer do
  #   match '/signin',  to: 'sessions#new',         via: 'get'
  #   match '/signin',  to: 'sessions#create',      via: 'post'
  # end

  match '/set_locale/:locale', to: 'application#set_locale_manually', via: 'get', as: :set_locale

  namespace :organizers, path: "organizer", shallow_path: "organizer" do
    resources :events do
      member do
        patch :publish
      end
    end
    resources :conferences, module: :events do
      member do
        get :present
      end
    end
  end

  resources :tags, only: [:index, :show]
  resources :questions, only: [:index], constraints: { token: /([a-z]|[0-9])+/i }
  resources :event_code_requests, only: [:new, :create] do
    collection do
      get :show
    end
  end

  get "pages/faq"
  get "pages/about"
  get "pages/features"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "dashboard" => "users#index"
  get ":id" => "users#show"

  # You can have the root of your site routed with "root"
  root 'pages#landing'
end
