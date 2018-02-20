class MfaHookListener < Redmine::Hook::ViewListener

  render_on :view_my_account_preferences, :partial => "acceptto_mfa/account_preferences"
  render_on :view_layouts_base_html_head

  def view_layouts_base_html_head(context = {})
    javascript_include_tag 'bfp.js', :plugin => 'acceptto_mfa'
  end

  def controller_account_success_authentication_after(context={})
    user = User.current
    context[:request].session[:channel] = nil

    unless user.mfa_access_token.present? # create access token
      url = "#{Setting.plugin_acceptto_mfa['mfa_site']}/api/v9/create_token"
      token_options = { :body => { uid:Setting.plugin_acceptto_mfa['app_uid'], secret:Setting.plugin_acceptto_mfa['app_secret'], email: user.email_address&.address } }
      resp = HTTParty.send("post", url = url, options = token_options)
      json_response = JSON.parse(resp.body.encode('UTF-8'))
      p "**********************************************"
      p "Create Token API result: #{json_response.inspect}"
      p "**********************************************"
      if json_response['success'] == true
        user.mfa_access_token = json_response['token']
        user.save
      end
    end

    if user.mfa_access_token.present?
      user.update_attribute(:mfa_authenticated, false)

      @channel = ''
      options = {}
      options[:oauth] = true
      options[:type] = 'Login'
      options[:message] = Setting.plugin_acceptto_mfa['auth_message']
      options[:fingerprint] = context[:request].cookies["fingerprint"] if context[:request].cookies["fingerprint"]
      options[:timeout] = Setting.plugin_acceptto_mfa['auth_timeout']
      options[:ip_address] = context[:request].ip
      options[:remote_ip_address] = context[:request].remote_ip
      options[:hash1] = context[:request].cookies["hash1"] if context[:request].cookies["hash1"]
      options[:hash2] = context[:request].cookies["hash2"] if context[:request].cookies["hash2"]
      options[:hash3] = context[:request].cookies["hash3"] if context[:request].cookies["hash3"]
      options[:hash4] = context[:request].cookies["hash4"] if context[:request].cookies["hash4"]
      oauth_client = OAuth2::Client.new(Setting.plugin_acceptto_mfa['app_uid'],Setting.plugin_acceptto_mfa['app_secret'], :site => Setting.plugin_acceptto_mfa['mfa_site'])
      access = OAuth2::AccessToken.from_hash(oauth_client, {:access_token => user.mfa_access_token})
      response = access.post('/api/v9/authenticate_with_options', :params => options ).parsed
      status = response['status']
      if status == "approved"
        user.update_attribute(:mfa_authenticated, true)
      else
        context[:request].session[:channel] = response['channel'] unless response.blank?
      end
    end
  end
end
