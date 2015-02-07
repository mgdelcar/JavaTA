class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception if Rails.env.production?

  before_action :require_login
 
  private
 
  def require_login
    # TODO: If there is no administrator defined, create an admin account first
    # TODO: Allow only users with the right permissions to access this controller
    if session[:user_id].nil?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url # halts request cycle
    end
  end
end
