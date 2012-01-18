ActionController::Routing::Routes.draw do |map|
  map.resources :contests

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.connect '', :controller => 'home'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'admin', :controller => 'admin', :action => 'overview'
  map.connect 'admin/scaffold_index', :controller => 'admin', :action => 'index'

  map.update_email('users/update_email', :controller => 'users', :action => 'update_email')
  map.activate_new_email('users/activate_new_email/:id', :controller => 'users', :action => 'activate_new_email')
  map.update_profile('users/update_profile', :controller => 'users', :action => 'update_profile')
  map.update_password('users/update_password', :controller => 'users', :action => 'update_password')
  map.forgot_password('users/forgot_password', :controller => 'users', :action => 'forgot_password')
  map.reset_password('users/reset_password/:id', :controller => 'users', :action => 'reset_password')

  map.resources :notes, :controller => :comments

  map.resources :users do |user|
    user.resources :stories
    user.resources :favorite_stories
    user.resources :favorite_authors
    user.resources :favoriteds, :name_prefix => 'author_', :controller => :author_favoriteds
    user.resources :notes, :controller => :comments
  end 

  map.resource  :session
  map.home "/", :controller => "home", :action => "index"
  map.signup "/signup", :controller => "sessions", :action => "signup"
  map.login  "/login", :controller => "sessions", :action => "login"

  map.resources :stories, :collection => { :recent => :get } do |story|
    story.resources :favoriteds, :controller => :story_favoriteds
    story.resources :notes, :controller => :comments, :collection => { :create_response => :post }
  end
  map.tagged_stories('stories/tagged/:tag_name', :controller => 'stories', :action => 'tagged')

  #############################################################################
  #############################################################################
  #############################################################################
  ##                                                                      #####
  ## (BH) We used to have a default route like ':controller/:action/:id'  #####
  ## here. This is no longer the case and it must not be added again.     #####
  ##                                                                      #####
  ## Our manage controllers are now accept RESTfull routing, by adding    #####
  ## the generic route here, we would allow any API method to be called   #####
  ## with any HTTP verb. I.e. we would have destructive HTTP GETs. We     #####
  ## cannot allow this, and using before_filters is not as an effective   #####
  ## protection as removing the generic rule.                             #####
  ##                                                                      #####
  ## In the longer term all controllers will be transformed to REST or    #####
  ## atleast converted to named routes. Till then I've added the          #####
  ## exception rules here. It will only get better!                       #####
  ##                                                                      #####
  ## This comment is originally Dee's from Harvest.  For Scrawlers I just #####
  ## didn't like dealing with things that passed through to the default   #####
  ## route                                                                #####
  ##                                                                      #####
    map.connect "admin/:action/:id", :controller => "admin"               #####
    map.connect "feed/:action/:id", :controller => "feed"                 #####
    map.connect "home/:action/:id", :controller => "home"                 #####
    map.connect "sessions/:action/:id", :controller => "sessions"         #####
    map.connect "stories/:action/:id", :controller => "stories"           ##### *
    map.connect "the_scrawl/:action/:id", :controller => "the_scrawl"     #####
    map.connect "users/:action/:id", :controller => "users"               ##### *
  ##                                                                      #####
  ##  BIG FAT NOTE: see above and do not add a generic route              #####
  ##  like ':controller/:action/:id' here. IT WILL BREAK THINGS!          #####
  ##                                                                      #####
  ##  TODO: * - remove when fully RESTful                                 #####
  ##                                                                      #####
  #############################################################################
  #############################################################################
  #############################################################################  


  # Install the default route as the lowest priority.
  # map.connect ':controller/:action/:id'
  
  # Catchall route for any unmatched routes. This is to catch blog references.
  # All others are served a 404.
  map.catchall '*path', :controller => 'redirect'

end
