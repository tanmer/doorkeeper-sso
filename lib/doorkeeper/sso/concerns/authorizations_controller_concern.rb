module Doorkeeper::SSO::Concerns
  module AuthorizationsControllerConcern
    def after_successful_authorization
      if pre_auth.client.application.sso
        sso_session = Doorkeeper::SSO::Session.sign_in!(self)
        access_grant = strategy.request.instance_variable_get(:@response).auth.token
        access_grant.sso_session_guid = sso_session.guid
        access_grant.save!
      end
      super
    end
  end
end
