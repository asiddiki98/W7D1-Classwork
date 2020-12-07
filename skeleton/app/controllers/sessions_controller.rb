class SessionsController < ApplicationController


  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
      )

      if user
          login(user)
          redirect_to cats_url
      else
        flash.now[:errors] = ['Invalid credentials']
        render :new
      end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url #login page
  end


end

# When do we arrive at the SessionsController? 
# Homepage seems to be cats_url
