require_dependency 'application_controller'

module ApplicationControllerPatch

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

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      $mfa_app_uid = Rails.configuration.respond_to?(:mfa_app_uid) ? Rails.configuration.mfa_app_uid : '82441b628e122e6d7137d2ba94a8de79973ba6da333f9d68f8ec3ab7bf1b3b6d'
      $mfa_app_secret = Rails.configuration.respond_to?(:mfa_app_secret) ? Rails.configuration.mfa_app_secret : 'c00be1fd3696c537956d8b4a39ae106ed5df12cbb8396c9edade7f7c36b1343a'
      unloadable
      before_action :mfa_authentication_required
    end
  end
end

Rails.configuration.to_prepare do
  ApplicationController.send(:include, ApplicationControllerPatch)
end
