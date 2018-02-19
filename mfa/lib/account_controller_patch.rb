require_dependency 'account_controller'

module AccountControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      skip_before_action :mfa_authentication_required
    end
  end

  module InstanceMethods
  end
end

Rails.configuration.to_prepare do
  AccountController.send(:include, AccountControllerPatch)
end
