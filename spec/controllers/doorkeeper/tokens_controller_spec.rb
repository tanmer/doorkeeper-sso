require 'rails_helper'

RSpec.describe Doorkeeper::TokensController, type: :controller do
  let!(:application) { Doorkeeper::Application.create!(name: 'example1', sso: true, redirect_uri: 'urn:ietf:wg:oauth:2.0:oob') }
  let!(:user) { User.create! name: 'user1' }
  let!(:sso_session) { Doorkeeper::SSO::Session.create! resource_owner_id: user.id }
  let!(:access_grant) { application.access_grants.create! sso_session_guid: sso_session.guid, resource_owner_id: sso_session.resource_owner_id, expires_in: 10.minutes.since, redirect_uri: application.redirect_uri, scopes: application.scopes }

  it { should be_kind_of Doorkeeper::SSO::Concerns::TokensControllerConcern }

  it 'create' do
    post :create, params: { grant_type: 'authorization_code',
                            code: access_grant.token,
                            client_id: application.uid,
                            client_secret: application.secret,
                            redirect_uri: application.redirect_uri },
                  format: :json

    json = JSON.parse(response.body)
    access_token = Doorkeeper::AccessToken.find_by(token: json['access_token'])
    expect(access_token.sso_session_guid).to eq sso_session.guid
  end

  context "with access token" do
    let!(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, scopes: application.scopes, sso_session_guid: sso_session.guid)}
    it 'revoke' do
      post :revoke, params: { token: access_token.token, client_id: application.uid, client_secret: application.secret }
      sso_session.reload
      expect(response.status).to eq 200
      expect(sso_session.signed_out).to be true
      expect(sso_session.access_grants.map(&:revoked?).all?).to be true
      expect(sso_session.access_tokens.map(&:revoked?).all?).to be true
      expect(cookies[Doorkeeper::SSO.cookie_name]).to be_nil
    end
  end
end
