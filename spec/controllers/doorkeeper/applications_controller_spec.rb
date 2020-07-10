require 'rails_helper'

RSpec.describe Doorkeeper::ApplicationsController, type: :controller do
  before do
    user = User.create!(name: 'user1')
    user_session = Doorkeeper::SSO::Session.create!(resource_owner_id: user.id)
    cookies[Doorkeeper::SSO.cookie_name] = user_session.guid
    session[:user_id] = user.id
  end
  it { should be_kind_of Doorkeeper::SSO::Concerns::ApplicationsControllerConcern }
  it do
    params = {
      doorkeeper_application: {
        name: 'app1',
        redirect_uri: 'callback',
        scopes: 'public',
        confidential: true,
        is_sso: true
      }
    }
    should permit(:name, :redirect_uri, :scopes, :confidential, :is_sso).for(:create, params: params).on(:doorkeeper_application)
  end
end
