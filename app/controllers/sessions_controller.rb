class SessionsController < ApplicationController
  def new
  end
  # def create
  #   user = User.find_by_username(params[:username])
  #   if user && user.authenticate(params[:password])
  #     session[:user_id] = user.id
  #     redirect_to root_url, :notice => "Logged in"
  #   else
  #     flash.now.alert = "Invalid email or password"
  #     render "new"
  #   end
  # end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    session[:password] = nil
    
    redirect_to root_url, :notice => "Logged out"
  end
  
  
  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']
    
    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every service
      
      # create a new hash
      @authhash = Hash.new
      
      if service_route == 'facebook'
        omniauth['extra']['user_hash']['email'] ? @authhash[:email] =  omniauth['extra']['user_hash']['email'] : @authhash[:email] = ''
        omniauth['extra']['user_hash']['username'] ? @authhash[:name] =  omniauth['extra']['user_hash']['username'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ?  @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''

        omniauth['user_info']['image'] ? @authhash[:photo] =  omniauth['user_info']['image'] : @authhash[:photo] = ''
        
        @authhash[:token] = ""
        @authhash[:secret] = ""
        
      elsif service_route == 'twitter'
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['nickname'] ? @authhash[:name] =  omniauth['user_info']['nickname'] : @authhash[:name] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''        

        omniauth['user_info']['image'] ? @authhash[:photo] = omniauth['user_info']['image'] : @authhash[:photo] = ''        
        
        omniauth['credentials']['token'] ? @authhash[:token] = omniauth['credentials']['token'] : @authhash[:token] = ''        
        omniauth['credentials']['secret'] ? @authhash[:secret] = omniauth['credentials']['secret'] : @authhash[:secret] = ''        
                        
      else        
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end 
      
      if @authhash[:uid] != '' and @authhash[:provider] != ''
        
        auth = User.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        if auth 
          session[:user_id] = auth.id
          session['access_token'] = auth.access_token
          session['access_secret'] = auth.access_secret
          
          # redirect_to "/feed", :notice => "Logged in"
          redirect_to "/", :notice => "Logged in"
        else

          # puts omniauth['uid']
          # puts omniauth['user_info']['nickname']
          # puts omniauth['user_info']['name']
          # puts omniauth['user_info']['email']
          # puts omniauth['user_info']['image']
          # puts omniauth['user_info']['description']
          # puts omniauth['credentials']['token']
          # puts omniauth['credentials']['secret']

          @user = User.new
          @user.username = @authhash[:name]
          @user.email = @authhash[:email]
          @user.provider = @authhash[:provider]
          @user.uid = @authhash[:uid]
          @user.photo = @authhash[:photo]  
          @user.password = rand(10000000)        
          @user.allowemail = true
          @user.access_token = @authhash[:token]  
          @user.access_secret = @authhash[:secret]  

          @user.save
          
          if !@user.email.nil?
            # Send welcome email
            @message = "Welcome to AppStore!"
            Notifier.contact(@authhash[:email], "chris@tropo.com", @message).deliver
          end 
          
          session[:user_id] = @user.id      
          session['access_token'] = @user.access_token
          session['access_secret'] = @user.access_secret
          # redirect_to "/feed", :notice => "User was successfully created."
          redirect_to "/", :notice => "User was successfully created."

        end
        
      else
        flash[:notice] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to root_url
      end
    else
        # user = User.find_by_username(params[:username])
        # if user && user.authenticate(params[:password])
        #   session[:user_id] = user.id
        #   redirect_to "/feed", :notice => "Logged in"
        # else
        #   flash.now.alert = "Invalid email or password"
        #   render "new"
        # end

        evosso = "http://evolution.voxeo.com/api/account/accesstoken/get.jsp?username=#{params[:username]}&password=#{params[:password]}"
        result = RestClient.get evosso
    	  data = JSON.parse(result)
    	  if data["account-accesstoken-get-response"]["statusCode"] == 200

          troposso = "http://www.tropo.com/atLogin?accessToken=" + data["account-accesstoken-get-response"]["accessToken"] + "&path=/applications"
          session[:username] = params[:username]
          session[:password] = params[:password]
          redirect_to "/apps", :alert => "Logged in."
        else
          redirect_to "/", :alert => "Something went wrong."
        end


    end
  end
  
  # callback: failure
  def failure
    flash[:notice] = 'There was an error at the remote authentication service. You have not been signed in.'
    redirect_to root_url
  end  
  
end
