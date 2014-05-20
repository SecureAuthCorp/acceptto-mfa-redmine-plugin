class MfaHookListener < Redmine::Hook::ViewListener
  
  render_on :view_my_account_preferences, :partial => "mfa/account_preferences" 
  
  def controller_account_success_authentication_after(context={} )
    user = User.current
    
    if user.mfa_access_token.present?
      user.update_attribute(:mfa_authenticated, false)
      call_back_url = "#{Rails.configuration.redmine_host}/mfa/callback"
			acceptto = Acceptto::Client.new(Rails.configuration.mfa_app_uid, Rails.configuration.mfa_app_secret, call_back_url)
			@channel = acceptto.authenticate(user.mfa_access_token, l(:mfa_redmine_wishing_authorize), l(:mfa_authetication_type))
      context[:params][:back_url] = "#{Rails.application.config.redmine_host}/mfa/index?channel=#{@channel}"
    end
  end
end