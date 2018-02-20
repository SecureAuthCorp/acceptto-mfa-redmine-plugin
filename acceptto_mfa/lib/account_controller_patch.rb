require_dependency 'account_controller'

module AccountControllerPatch
  def self.included(base)
    base.class_eval do
      unloadable
      skip_before_action :mfa_authentication_required
    end
  end
end

Rails.configuration.to_prepare do
  AccountController.send(:include, AccountControllerPatch)
end
