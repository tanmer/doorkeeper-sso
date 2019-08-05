require 'rails_helper'

module Doorkeeper::SSO
  RSpec.describe Session, type: :model do
    describe 'class' do
      subject { Session }
      it { expect(subject.primary_key).to eq('guid') }
      it { expect(subject.table_name).to eq('oauth_sso_sessions') }
      it { should respond_to :from_cookie }
      it { should respond_to :sign_in! }
      it { should respond_to :sign_out! }
      it { should respond_to :sign_out_by_guid! }
    end
    it { should have_many(:access_tokens).class_name('Doorkeeper::AccessToken').with_foreign_key(:sso_session_guid).dependent(:nullify) }
    it { should have_many(:access_grants).class_name('Doorkeeper::AccessGrant').with_foreign_key(:sso_session_guid).dependent(:nullify) }

    context 'a session' do
      subject { Doorkeeper::SSO::Session.create! }
      let!(:application) { Doorkeeper::Application.create!(name: 'example1', redirect_uri: 'urn:ietf:wg:oauth:2.0:oob') }
      let!(:access_grant) { application.access_grants.create! sso_session_guid: subject.guid, resource_owner_id: 1, expires_in: 10.minutes.since, redirect_uri: application.redirect_uri }
      let!(:access_token) { application.access_tokens.create! sso_session_guid: subject.guid }

      it('has default 32 chars guid') { expect(subject.guid.length).to eq 32 }
      it { should_not be_signed_out }
      it { expect(subject.access_grants.exists?(access_grant.id)).to be true }
      it { expect(subject.access_tokens.exists?(access_token.id)).to be true }
      it { expect(access_grant.revoked?).to be false }
      it { expect(access_token.revoked?).to be false }
      it { should respond_to :write_cookie }

      describe 'sign_out!' do
        before { subject.sign_out! ; subject.reload; access_grant.reload; access_token.reload;}
        it { should be_signed_out }
        it { expect(subject.access_grants.exists?(access_grant.id)).to be true }
        it { expect(subject.access_tokens.exists?(access_token.id)).to be true }
        it { expect(access_grant.revoked?).to be true }
        it { expect(access_token.revoked?).to be true }
      end
    end
  end
end
