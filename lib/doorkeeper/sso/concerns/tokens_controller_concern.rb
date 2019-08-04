module Doorkeeper::SSO::Concerns
  module TokensControllerConcern
    def authorize_response
      v = super
      if strategy.request.client.application.sso
        v.token.sso_session_guid = strategy.request.grant.sso_session_guid
        v.token.save!
      end
      v
    end

    def revoke

      binding.pry

    end

    def revoke_token
      super
      if token.application.sso && token.sso_session_guid
        Doorkeeper::SSO::Session.sign_out_by_guid!(token.sso_session_guid)
      end
    end
  end
end
