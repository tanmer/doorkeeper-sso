module Doorkeeper::SSO::Concerns
  module AuthorizationsControllerConcern
    def after_successful_authorization(context)
      if pre_auth.client.application.is_sso
        sso_session = Doorkeeper::SSO::Session.sign_in!(self)
        access_grant = context.issued_token
        access_grant.sso_session_guid = sso_session.guid
        access_grant.save!
      end
      super
    end
  end
end
