module Doorkeeper::SSO::Concerns
  module TokensControllerConcern
    def authorize_response
      super.tap do |resp|
        if resp.is_a?(Doorkeeper::OAuth::TokenResponse)
          if strategy.request.client.application.is_sso && resp.token.sso_session_guid.nil?
            resp.token.update_columns sso_session_guid: strategy.request.grant.sso_session_guid
          end
        end
      end
    end

    def revoke_token
      super
      if token.application.is_sso && token.sso_session_guid
        Doorkeeper::SSO::Session.sign_out_by_guid!(token.sso_session_guid)
      end
    end
  end
end
