class MfaHookListener < Redmine::Hook::ViewListener
  
  render_on :view_my_account_preferences, :partial => "mfa/account_preferences" 
  
  def controller_account_success_authentication_after(context={} )
    user = User.current
    
    if user.mfa_access_token.present?
      user.update_attribute(:mfa_authenticated, false)
      access = OAuth2::AccessToken.from_hash(client, {access_token: user.mfa_access_token})
      response = access.post("/api/v4/authenticate", params: {message: l(:mfa_redmine_wishing_authorize), meta_data: {type: l('mfa_authetication_type')}}).parsed
      @channel = response["channel"]
      context[:params][:back_url] = "#{Rails.application.config.redmine_host}/mfa/index?channel=#{@channel}"
    end
  end
  
  def client
    @client ||= OAuth2::Client.new(Rails.application.config.mfa_app_id, Rails.application.config.mfa_secret, site: Rails.application.config.mfa_site)
  end
end