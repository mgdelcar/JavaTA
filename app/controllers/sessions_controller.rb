# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :failure]

  def new
    @link = Rails.env.production? ? '/auth/google_oauth2' : '/auth/developer'
  end

  def create
    start_page = '/problem_submissions'
    failure_page = '/auth/failure'

    unless session[:user_id].nil?
      redirect_to start_page
      return
    end

    auth = request.env['omniauth.auth']
    provider = auth['provider']

    logger.info "Trying to log in with the following information #{auth}".green

    if auth.nil? || provider.nil?
      redirect_to failure_page
      return
    end

    if provider.eql?('google_oauth2')
      logger.info "Using google OAuth2".green

      credentials = auth['credentials']

      @info = auth['info']
      logger.info "User info is #{@info}".green

      # TODO: Link the token to the user name
      Token.create(
        access_token: credentials['token'],
        refresh_token: credentials['refresh_token'],
        expires_at: Time.at(credentials['expires_at']).to_datetime)
    elsif provider.eql?('developer')
      @info = auth['info']
    else
      redirect_to failure_page
      return
    end

    logger.info "Looking for user with email #{@info['email']}".green
    
    if (User.count == 0)
      user = User.create(:email => @info['email'], :name => @info['first_name'], :last_name => @info['last_name'], :user_type => :admininstrator)
    else
      user = User.find_by_email(@info['email'])
    end
    
    if user.nil?
      redirect_to failure_page
      return
    end

    logger.info "Logging is as user #{user}".green

    session[:user_id] = user.id
    redirect_to start_page, :notice => "Signed in!"
  end

  def failure
    # TODO: Process a call like=GET path="/auth/failure?message=invalid_credentials&origin=http%3A%2F%2Fjava-ta.herokuapp.com%2F&strategy=google_oauth2" host=java-ta.herokuapp.com request_id=0367ede6-9209-4817-8527-d499a31e312e fwd="73.53.56.252" dyno=web.1 connect=1ms service=8ms status=404 bytes=1758
    session[:user_id] = nil
    flash[:error] = "Could not log in as the user provided"
    redirect_to '/problem_submissions'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end