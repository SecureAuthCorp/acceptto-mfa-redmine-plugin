Redmine::Plugin.register :acceptto_mfa do
  name 'Multi-Factor Authentication plugin'
  author 'Acceptto Corp'
  description 'Acceptto Multi-Factor Authentication plugin for redmine'
  version '1.0.0'
  url 'http://mfa.acceptto.com/redmine'
  author_url 'http://mfa.acceptto.com'

  require_dependency 'mfa_hook_listener'

  Rails.configuration.to_prepare do
    ApplicationController.send(:include, ApplicationControllerPatch)
    AccountController.send(:include, AccountControllerPatch)
  end
end
