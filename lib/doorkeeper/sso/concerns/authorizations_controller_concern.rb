module Doorkeeper::SSO::Concerns
  module AuthorizationsControllerConcern
    def after_successful_authorization
      if pre_auth.client.application.sso
        sso_session = Doorkeeper::SSO::Session.find_or_initialize_by(guid: sso_session_guid)
        sso_session.resource_owner_id = authorization.resource_owner.id
        sso_session.user_agent = request.user_agent
        sso_session.ip_address = request.remote_ip
        sso_session.save! if sso_session.changed?
        access_grant = strategy.request.instance_variable_get(:@response).auth.token
        access_grant.sso_session_guid = sso_session.guid
        access_grant.save!
      end
      super
    end

    def sso_session_guid
      if cookies[Doorkeeper::SSO.cookie_name].blank?
        cookies[Doorkeeper::SSO.cookie_name] = {
          value: SecureRandom.hex,
          expires: 10.years,
          httponly: true
        }
      end
      cookies[Doorkeeper::SSO.cookie_name]
    end
  end
end
