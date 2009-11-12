ActionController::Routing::Routes.draw do |map|
  
  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
