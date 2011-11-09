class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def omniauth
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def admin_user
    if session[:username] == "cmatthieu" or session[:username] == "jdyer"  or session[:username] == "jsgoecke" or session[:username] == "akalsey"
      @admin = true
    else
      @admin = false
    end
  end

  def current_user
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= session[:username]
  end
  helper_method :current_user
  
  def admin_required
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= session[:username]

    if @current_user 
      if session[:username] != "cmatthieu" and session[:username] != "jdyer" and session[:username] != "jsgoecke" and session[:username] != "akalsey" #!@current_user.admin
        @admin = false
        redirect_to '/'
      else
        @admin = true
      end
    else
      @admin = false
       redirect_to '/'
    end
  end
  
  def user_signed_in?
    return 1 if current_user 
  end
  

  def login_required
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= session[:username]

    if !@current_user 
       redirect_to '/'
    end
  end

  def isNumeric(s)
      Float(s) != nil rescue false
  end
  
  def client
    Twitter.configure do |config|
      config.consumer_key = '' #ENV['CONSUMER_KEY']
      config.consumer_secret = '' #ENV['CONSUMER_SECRET']
      # Gospelr's tokens for verse tweets
      config.oauth_token = '' #session['access_token']
      config.oauth_token_secret = '' #session['access_secret']
    end
    @client ||= Twitter::Client.new
  end  

end
