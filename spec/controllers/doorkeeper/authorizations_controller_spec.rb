require 'rails_helper'

RSpec.describe Doorkeeper::AuthorizationsController, type: :controller do
  let!(:application) { Doorkeeper::Application.create!(name: 'example1', is_sso: true, redirect_uri: 'urn:ietf:wg:oauth:2.0:oob', scopes: 'public', confidential: true) }

  before do
    user = User.create name: 'user1'
    Doorkeeper::SSO::Session.sign_in! subject, user: user do |session:, **_|
      session[:user_id] = user.id
    end
  end

  it { should be_kind_of Doorkeeper::SSO::Concerns::AuthorizationsControllerConcern }

  describe "sso application" do
    before { application.update is_sso: true }
    it 'create' do
      post :create, params: { client_id: application.uid,
                              redirect_uri: application.redirect_uri,
                              response_type: 'code',
                              scope: 'public' }
      s = Doorkeeper::SSO::Session.from_cookie(cookies)
      code = s.access_grants.first.token
      expect(response.body).to match %r{http://test\.host/oauth/authorize/native\?code=#{code}}
    end
  end

  describe "not a sso application" do
    before { application.update is_sso: false }
    it 'create' do
      post :create, params: { client_id: application.uid,
                              redirect_uri: application.redirect_uri,
                              response_type: 'code',
                              scope: 'public' }
      s = Doorkeeper::SSO::Session.from_cookie(cookies)
      expect(s.access_grants.first).to be_nil
      expect(response.body).to match %r{http://test\.host/oauth/authorize/native\?code=}
    end
  end

end
