Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'search/index'

  devise_for :users, :controllers => { :registrations => "registrations" }

  get 'startpage/index'
  get 'startpage/entry'
  get 'startpage/first_steps'

  # You can have the root of your site routed with "root"
  root 'startpage#entry'

  #get 'static_pages/help'
  get 'static_pages/recommendations'
  get 'static_pages/impressum'
  get 'static_pages/contact'
  post 'static_pages/contact'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :plants do
    member do
      post  'clone'
      post  'vote'
      post  'unvote'
      patch 'activate'
      patch 'inactivate'
      get   'download_main_image'
    end
    resources :tasks do
      member do
        patch 'hide'
        patch 'unhide'
      end
      resources :done_tasks, except: :index
      resources :task_images, only: [:download_task_image, :create, :update, :destroy] do
        member do
          get 'download_task_image'
        end
      end
    end
    resources :comments, only: [:index, :destroy, :create]
    get 'done_tasks/index'
  end

  resources :users, except: :new do
    member do
      get 'download_picture'
    end
  end
  post 'users/invite'

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
end
