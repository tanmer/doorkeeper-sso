class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_or_create_by!(name: params[:user][:name])
    Doorkeeper::SSO::Session.sign_out!(self)
    Doorkeeper::SSO::Session.sign_in!(self, user: user) do |session:, **_|
      session[:user_id] = user.id
    end
    redirect_to oauth_applications_path
  end

  def destroy
    Doorkeeper::SSO::Session.sign_out!(self) do |session:, **_|
      session.delete :user_id
    end
    redirect_to oauth_applications_path
  end
end
