class MfaController < ApplicationController
  unloadable
  skip_before_filter :mfa_authentication_required
  
  def index
    @channel = params[:channel]
  end

  def check
    user = User.current
    if user.nil?
      flash[:error] = l(:mfa_user_session_expired)
      return redirect_back_or_default signin_path
    end
    
    user = User.current
    
    access = OAuth2::AccessToken.from_hash(client, {:access_token => user.mfa_access_token })
    response = access.post("/api/v4/check", { body: {:channel => params[:channel]} }).parsed
    if response["status"] == "approved"
      user.update_attribute(:mfa_authenticated, true)
      flash[:notice] = l(:mfa_enable_acceptted)
      return redirect_back_or_default my_page_path
    elsif response["status"] == "rejected"
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
  
  private
  
  def client
    @client ||= OAuth2::Client.new(Rails.application.config.mfa_app_id, Rails.application.config.mfa_secret, site: Rails.application.config.mfa_site)
  end
  
end
