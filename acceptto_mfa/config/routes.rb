# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'mfa/check', :controller => 'mfa', :action => 'check', :via => :get
match 'mfa/callback', :controller => 'mfa', :action => 'callback', :via => :get
match 'mfa/status', :controller => 'mfa', :action => 'status', :via => :get
