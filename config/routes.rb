Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :gift_cards
  end
end
