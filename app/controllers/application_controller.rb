class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_admin
    if !logged_in? || !current_user.admin?
      flash[:error] = "You need admin rights to do that."
      redirect_to root_path
    end
  end

  def require_user
    if !logged_in?
      flash[:error] = "You need to be logged in to do that."
      redirect_to sign_in_path
    end
  end
end
