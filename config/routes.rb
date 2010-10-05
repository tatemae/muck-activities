Rails.application.routes.draw do
  resources :activities, :controller => 'muck/activities'
end