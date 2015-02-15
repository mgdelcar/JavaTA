class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception if Rails.env.production?

  helper_method :current_user, :logged_in?

  before_action :require_login

  protected
 
  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    @user ||= User.find(session[:user_id])
  end

  private
 
  def require_login
    # TODO: If there is no administrator defined, create an admin account first
    # TODO: Allow only users with the right permissions to access this controller
    unless logged_in?
      error_message = "You must be logged in to access this section"
      flash[:error] = error_message
      redirect_to root_url, :notice => error_message # halts request cycle
    end
  end
end
