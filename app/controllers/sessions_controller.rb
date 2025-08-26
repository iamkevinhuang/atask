class SessionsController < ApplicationController
  before_action :authenticate_user!, except: [:create]

  # POST /login
  def create
    auth = User.authenticate(params[:username], params[:password], request.user_agent)

    if auth[:success]
      render json: { auth_token: auth[:data][:auth_token], user: auth[:data][:user] }, status: :ok
    else
      render json: { error: auth[:data][:error] }, status: :unauthorized
    end
  end

  # GET /me
  def show
    render json: UserBlueprint.render_as_hash(@current_user), status: :ok
  end

  # DELETE /logout
  def destroy
    @current_user.sessions.find_by(auth_token: get_token)&.destroy
    render json: { message: I18n.t('session.messages.logged_out') }, status: :ok
  end
end
