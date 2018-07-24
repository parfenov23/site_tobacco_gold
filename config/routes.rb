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
  get "current_magazine/:current_magazine" => "home#current_magazine"

  get "sign_in" => "home#sign_in"
  get "sign_up" => "home#sign_up"

  post "add_item_to_basket" => "home#add_item_to_basket"
  post "rm_item_to_basket" => "home#rm_item_to_basket"
  post "send_item_to_basket" => "home#send_item_to_basket"

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
end
