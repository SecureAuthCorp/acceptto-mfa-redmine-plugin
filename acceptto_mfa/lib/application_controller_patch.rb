require_dependency 'application_controller'

module ApplicationControllerPatch

  module InstanceMethods
    def mfa_authentication_required
      user = User.current
      if !user.nil? && !user.mfa_access_token.blank? && user.mfa_authenticated == false
        # flash[:error] = l(:mfa_required)
        # logout_user
        # redirect_to signin_url
        if session[:channel]
          callback_url = "#{request.protocol + request.host_with_port}/mfa/check"
          redirect_url = "#{Setting.plugin_acceptto_mfa['mfa_site']}/mfa/index?channel=#{session[:channel]}&callback_url=#{callback_url}"
          redirect_to redirect_url
        end
      end
    end
  end

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      before_action :mfa_authentication_required
    end
  end
end

Rails.configuration.to_prepare do
  ApplicationController.send(:include, ApplicationControllerPatch)
end
