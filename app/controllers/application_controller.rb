class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception if Rails.env.production?

  helper_method :current_user, :logged_in?, :start_page

  before_action :require_login, :controller_allowed?

  protected
 
  def logged_in?
    !session[:user_id].nil?
  end

  def current_user
    if session[:user_id].nil?
      @current_user = nil
    else
      @current_user ||= User.find(session[:user_id])
    end
  end

  def start_page
    if current_user.nil?
      return '/logout'
    elsif current_user.student?
      return '/problem_submissions'
    elsif current_user.instructor?
      return '/problems'
    elsif current_user.admininstrator?
      return '/users'
    else
      return '/logout'
    end
  end

  def controller_allowed?
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

