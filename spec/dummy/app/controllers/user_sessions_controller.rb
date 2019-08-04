class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_or_create_by(name: params[:user][:name])
    session[:user_id] = user.id
    cookies.delete(Doorkeeper::SSO.cookie_name)
    redirect_to oauth_applications_path
  end
end
