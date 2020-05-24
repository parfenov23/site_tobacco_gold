Rails.application.routes.draw do
  # devise_for :users

  get "how_it_works" => "home#how_it_works"
  get "item" => "home#item"
  get "item/:id" => "home#item"
  get "help" => "home#help"
  get "login" => "home#login"
  get "registration" => "home#registration"
  get "buy_rate" => "home#buy_rate"
  get "bonus" => "home#bonuses"
  get "contacts" => "home#contacts"
  get "all_mixs" => "home#all_mixs"
  get "mix_box/:id" => "home#mix_box"
  get "auth" => "home#auth"
  get "cabinet" => "home#cabinet"
  get "test_page" => "home#test_page"
  get "show_sale/:id" => "home#show_sale"
  get "page/:id" => "home#page"
  get "current_magazine/:current_magazine" => "home#current_magazine"
  get 'category/:category_id' => "home#category"
  get 'products/:product_id' => "home#products"
  get 'show_pdf_order_request/:id' => "home#show_pdf_order_request"

  get "sign_in" => "home#sign_in"
  get "sign_up" => "home#sign_up"
  get "reset_password" => "home#reset_password"
  get "ajax_search_product_item" => "home#ajax_search_product_item"

  post "add_item_to_basket" => "home#add_item_to_basket"
  post "rm_item_to_basket" => "home#rm_item_to_basket"
  post "send_item_to_basket" => "home#send_item_to_basket"
  post "add_or_rm_count_item_basket" => "home#add_or_rm_count_item_basket"
  post "update_user_contact" => "home#update_user_contact"
  post "user_reset_password" => "home#user_reset_password"

  #VK================
  get "callback_vk" => "home#callback_vk"
  post "callback_vk" => "home#callback_vk"
  #===================

  post "profile/update_ava" => "profile#update_ava"
  get "profile" => "profile#edit"
  put "profile" => "profile#update"
  get 'stock' => "admin/stock#index"



  # post "admin/create_attachment" => "admin#create_attachment"

  resources :users do
    collection do 
      post :auth
      get :sign_out
      post :registration
    end
  end


  root :to => "home#index"
  get '*unmatched_route', to: 'home#redirect_to_index'
end
