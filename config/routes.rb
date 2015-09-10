Rails.application.routes.draw do
  get 'missionary/orders'

  get 'missionary/orders_new'

  get 'missionary/special_questions'

  get 'missionary/special_questions_history'

  get 'missionary/recommendations'

  get 'missionary/baptismal_submission'

  get 'missionary/parent_contact'

  get 'admin/users'
  
  post 'admin/users'

  get 'admin/special_questions'

  get 'admin/special_questions_area'

  get 'admin/special_questions_area'

  get 'admin/special_questions_admin'

  get 'admin/orders'

  get 'admin/orders_fill'

  get 'admin/orders_fill_view'

  get 'admin/orders/inventory', to: 'admin#orders_inventory'

  get 'admin/orders_inventory_view'
  
  post 'admin/orders/inventory/ajax', to: 'admin#orders_inventory_ajax'
  
  get 'admin/orders/inventory/ajax', to: redirect('/admin/orders')

  get 'admin/parental_contact'

  get 'admin/recommendations'

  get 'admin/baptismal_submission'

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
end
