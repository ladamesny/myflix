class SessionsController < ApplicationController
  def new
    redirect_to videos_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome #{user.full_name}, you've successfully logged into myFlix!"
      redirect_to root_path
    else
      flash[:error] = "Something was wrong with your username or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out! Thank you for visiting."
    redirect_to root_path
  end
end
