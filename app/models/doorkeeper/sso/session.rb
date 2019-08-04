module Doorkeeper::SSO
  class Session < ApplicationRecord
    self.primary_key = 'guid'
    self.table_name = 'oauth_sso_sessions'

    with_options foreign_key: :sso_session_guid, dependent: :nullify do |o|
      o.has_many :access_tokens, class_name: 'Doorkeeper::AccessToken'
      o.has_many :access_grants, class_name: 'Doorkeeper::AccessGrant'
    end

    def sign_out!
      transaction do
        access_tokens.update_all revoked_at: Time.now
        access_grants.update_all revoked_at: Time.now
        update signed_out: true
      end
    end

    def self.sign_out_by_guid!(guid)
      find_by(guid: guid)&.sign_out!
    end
  end
end
