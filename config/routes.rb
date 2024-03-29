Rails.application.routes.draw do

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'mugshots#index'
   get '/admin/' => 'admin#index'
   get '/mugshots-admin/' => 'mugshots_admin#index'

   get 'sitemap' => 'mugshots#sitemap'
   get 'xml_sitemap' => 'mugshots#xml_sitemap'

   resources :mugshots do
     get :re_scrape_mugshot
   end

   resources :removals do
     resources :removalcharges
     resources :charges
   end

   resources :states, :path => '' do
     resources :counties, :path => '' do
       get :multi_offender_list
       get :re_scrape_mugshot
       resources :mugshots, :path => '', :except => [:index] do
         collection do
           get :re_scrape_mugshot
           get :modal
         end
         resources :photos
       end
     end
   end

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

end
