Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new', as: :registration
  scope :profile do
    get '/', to: 'users#show', as: :profile
    get '/edit', to: 'users#edit', as: :edit_profile
  end
  namespace :profile do
    resources :orders, only: [:index, :create, :show, :destroy]
  end

  resources :users, only: [:create, :update], param: :slug

  get '/cart', to: 'cart#show'
  post '/cart/item/:slug', to: 'cart#add', as: :cart_item
  post '/cart/addmoreitem/:slug', to: 'cart#add_more_item', as: :cart_add_more_item
  delete '/cart', to: 'cart#destroy', as: :cart_empty
  delete '/cart/item/:slug', to: 'cart#remove_more_item', as: :cart_remove_more_item
  delete '/cart/item/:slug/all', to: 'cart#remove_all_of_item', as: :cart_remove_item_all

  resources :items, only: [:index, :show], param: :slug

  scope :dashboard, as: :dashboard do
    get '/', to: 'merchants#show'
    resources :items, module: :merchants, param: :item_slug
    resources :coupons, module: :merchants
    put 'coupons/:id/enable', to: 'merchants/coupons#enable', as: :enable_coupon
    put 'coupons/:id/disable', to: 'merchants/coupons#disable', as: :disable_coupon
    put '/items/:item_slug/enable', to: 'merchants/items#enable', as: :enable_item
    put '/items/:item_slug/disable', to: 'merchants/items#disable', as: :disable_item
    get '/orders/:id', to: 'merchants/orders#show', as: :order
    put '/order_items/:id', to: 'merchants/order_items#update', as: :fulfill_order_item
  end

  resources :merchants, only: [:index, :show], param: :slug

  post '/admin/users/:slug/items', to: 'merchants/items#create', constraints: { slug: /[0-z\.]+/ }, as: 'admin_user_items'
  patch '/admin/users/:slug/items/:item_slug', to: 'merchants/items#update', constraints: { slug: /[0-z\.]+/ }, as: 'admin_user_item'

  namespace :admin do
    put '/users/:slug/enable', to: 'users#enable', constraints: { slug: /[0-z\.]+/ }, as: :enable_user
    put '/users/:slug/disable', to: 'users#disable', constraints: { slug: /[0-z\.]+/ }, as: :disable_user
    put '/users/:slug/upgrade', to: 'users#upgrade', constraints: { slug: /[0-z\.]+/ }, as: :upgrade_user
    resources :users, only: [:index, :show, :edit, :update], param: :slug, constraints: { slug: /[0-z\.]+/ } do
      resources :orders, only: [:index, :show]
    end

    put '/merchants/:slug/downgrade', to: 'merchants#downgrade', constraints: { slug: /[0-z\.]+/ }, as: :downgrade_merchant
    patch '/merchants/:slug/enable', to: 'merchants#enable', constraints: { slug: /[0-z\.]+/ }, as: :enable_merchant
    patch '/merchants/:slug/disable', to: 'merchants#disable', constraints: { slug: /[0-z\.]+/ }, as: :disable_merchant
    resources :merchants, only: [:show], param: :slug, constraints: { slug: /[0-z\.]+/ } do
      get '/orders/:id', to: 'orders#merchant_show', as: :order
      resources :items, only: [:index, :edit, :new], param: :item_slug
    end

    resources :dashboard, only: [:index]
  end
end
