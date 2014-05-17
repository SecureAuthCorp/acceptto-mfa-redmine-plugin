require_dependency 'application_controller'

module ApplicationControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      before_filter :mfa_authentication_required
    end
  end
  
  module InstanceMethods
    def mfa_authentication_required
      user = User.current 
      if !user.nil? && !user.mfa_access_token.blank? && user.mfa_authenticated == false
        flash[:error] = l(:mfa_required)
        logout_user
        redirect_to signin_url
      end
    end
  end
end

Rails.configuration.to_prepare do
  ApplicationController.send(:include, ApplicationControllerPatch)
end