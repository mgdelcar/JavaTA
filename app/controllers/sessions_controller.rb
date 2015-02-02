# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    @auth = request.env['omniauth.auth']['credentials']
    @info = request.env['omniauth.auth']['extra']['raw_info']
    Token.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime)
  end
end