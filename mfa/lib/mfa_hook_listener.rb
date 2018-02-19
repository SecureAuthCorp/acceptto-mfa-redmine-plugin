class MfaHookListener < Redmine::Hook::ViewListener

  render_on :view_my_account_preferences, :partial => "mfa/account_preferences"

  def controller_account_success_authentication_after(context={} )
    user = User.current

    if user.mfa_access_token.present?
      user.update_attribute(:mfa_authenticated, false)
      call_back_url = "#{context[:request].protocol + context[:request].host_with_port}/mfa/callback"
      uid = Rails.configuration.respond_to?(:mfa_app_uid) ? Rails.configuration.mfa_app_uid : '82441b628e122e6d7137d2ba94a8de79973ba6da333f9d68f8ec3ab7bf1b3b6d'
      secret = Rails.configuration.respond_to?(:mfa_app_secret) ? Rails.configuration.mfa_app_secret : 'c00be1fd3696c537956d8b4a39ae106ed5df12cbb8396c9edade7f7c36b1343a'
			acceptto = Acceptto::Client.new(uid, secret, call_back_url)

      @channel = ''
      options[:type] = mfa_type
      options[:message] = Rails.configuration.respond_to?(:mfa_message) ? Rails.configuration.mfa_message : 'Do you authorize redmine login?'
      options['hash1'] = context[:request].cookies[:hash1] if context[:request].cookies[:hash1]
      options['hash2'] = context[:request].cookies[:hash2] if context[:request].cookies[:hash2]
      options['hash3'] = context[:request].cookies[:hash3] if context[:request].cookies[:hash3]
      options['hash4'] = context[:request].cookies[:hash4] if context[:request].cookies[:hash4]
      access = OAuth2::AccessToken.from_hash(oauth_client, {:access_token =>  access_token})
      response = access.post('/api/v8/authenticate', :params => options ).parsed
      @channel = response['channel'] unless response.blank?
      context[:params][:back_url] = "#{Rails.application.config.redmine_host}/mfa/index?channel=#{@channel}"
    end
  end
end
