Redmine::Plugin.register :mfa do
  name 'Multi-Factor Authentication plugin'
  author 'Acceptto Corp'
  description 'Acceptto Multi-Factor Authentication plugin for redmine'
  version '0.0.1'
  url 'http://mfa.acceptto.com/redmine'
  author_url 'http://mfa.acceptto.com'
  
  require_dependency 'mfa_hook_listener'
  
end
