class MfaController < ApplicationController
  unloadable
  skip_before_action :mfa_authentication_required

  def check
    user = User.current
    if user.nil?
      flash[:error] = l(:mfa_user_session_expired)
      return redirect_back_or_default signin_path
    end

    session[:channel] = nil
    user = User.current
    oauth_client = OAuth2::Client.new(Setting.plugin_acceptto_mfa['app_uid'],Setting.plugin_acceptto_mfa['app_secret'], :site => Setting.plugin_acceptto_mfa['mfa_site'])
    access = OAuth2::AccessToken.from_hash(oauth_client, {:access_token => user.mfa_access_token})
    response = access.post('/api/v8/check', { :body => {:channel => params[:channel]}}).parsed
    status = response['status']

    if status == "approved"
      user.update_attribute(:mfa_authenticated, true)
      flash[:notice] = l(:mfa_enable_acceptted)
      return redirect_back_or_default my_page_path
    elsif status == "rejected"
      logout_user
      flash[:error] = l(:mfa_enable_rejected)
      return redirect_back_or_default signin_path
    else
      logout_user
      flash[:error] = l(:mfa_enable_timeout)
      return redirect_back_or_default signin_path
    end
  end

  def callback
    if params[:access_token].blank?
      flash[:error] = l(:mfa_access_denied)
      return redirect_to my_account_path
    end

    user = User.current
    user.mfa_access_token = params[:access_token]
    user.mfa_authenticated = true
    user.save
    flash[:notice] = l(:mfa_access_granted)
    redirect_to my_account_path
  end
end
