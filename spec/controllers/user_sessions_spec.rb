require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  it 'sign in and sign out' do
    expect(cookies[Doorkeeper::SSO.cookie_name]).to be_nil
    expect(session[:user_id]).to be_nil

    # sign in
    post :create, params: { user: { name: 'user1' } }

    guid = cookies[Doorkeeper::SSO.cookie_name]
    expect(guid).to_not be_nil
    sso_session = guid.presence && Doorkeeper::SSO::Session.find(guid)
    expect(sso_session).to_not be_nil
    expect(sso_session.resource_owner_id).to_not be_nil
    expect(session[:user_id]).to eq(sso_session.resource_owner_id)

    # sign out
    get :destroy
    expect(cookies[Doorkeeper::SSO.cookie_name]).to be_nil
    expect(session[:user_id]).to be_nil
    expect(sso_session.reload.signed_out).to be true
  end
end
