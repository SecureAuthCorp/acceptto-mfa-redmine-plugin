Redmine::Plugin.register :acceptto_mfa do
  name 'Acceptto Multi-Factor Authentication plugin'
  author 'Acceptto Corp'
  description 'Acceptto Multi-Factor Authentication plugin for redmine'
  version '1.1.0'
  url 'https://github.com/acceptto-corp/acceptto-mfa-redmine-plugin'
  author_url 'https://www.acceptto.com'

  require_dependency 'mfa_hook_listener'

  settings :default => {'mfa_site' => 'https://mfa.acceptto.com', 'auth_message' => 'Do you authorize redmine login?', 'app_uid' => '82441b628e122e6d7137d2ba94a8de79973ba6da333f9d68f8ec3ab7bf1b3b6d', 'app_secret' => 'c00be1fd3696c537956d8b4a39ae106ed5df12cbb8396c9edade7f7c36b1343a', 'auth_timeout' => '60'}, :partial => 'settings/acceptto_mfa_settings'

  Rails.configuration.to_prepare do
    ApplicationController.send(:include, ApplicationControllerPatch)
    AccountController.send(:include, AccountControllerPatch)
  end
end
