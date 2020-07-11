module Doorkeeper::SSO
  class Session < ApplicationRecord
    self.primary_key = 'guid'
    self.table_name = 'oauth_sso_sessions'

    before_validation :set_guid

    with_options foreign_key: :sso_session_guid, dependent: :nullify do |o|
      o.has_many :access_tokens, class_name: 'Doorkeeper::AccessToken'
      o.has_many :access_grants, class_name: 'Doorkeeper::AccessGrant'
    end

    def sign_out!
      transaction do
        access_tokens.each(&:revoke)
        access_grants.each(&:revoke)
        update signed_out: true
      end
    end

    def write_cookie(cookies)
      cookies[Doorkeeper::SSO.cookie_name] = { value: guid, expires: 10.years, httponly: true }
    end

    def self.sign_in!(controller, user: nil)
      sign_out!(controller)
      request = controller.send(:request)
      cookies = controller.send(:cookies)
      session = controller.send(:session)

      sso_session = from_cookie(cookies) || Doorkeeper::SSO::Session.new
      sso_session.resource_owner_id = user.id if user
      sso_session.user_agent = request.user_agent
      sso_session.ip_address = request.remote_ip
      sso_session.save! if sso_session.changed?
      sso_session.write_cookie cookies
      callback_args = { controller: controller, cookies: cookies,
                        session: session, sso_session: sso_session }
      Doorkeeper::SSO.on_signed_in.call(callback_args)
      yield callback_args if block_given?
      sso_session
    end

    # sign out from SSO page (eg. DELETE /sign-out)
    def self.sign_out!(controller)
      cookies = controller.send(:cookies)
      session = controller.send(:session)
      sso_session = from_cookie(cookies)
      sso_session.sign_out! if sso_session
      cookies.delete Doorkeeper::SSO.cookie_name
      callback_args = { controller: controller, cookies: cookies,
                        session: session, sso_session: sso_session }
      Doorkeeper::SSO.on_signed_out.call(callback_args)
      yield callback_args if block_given?
      sso_session
    end

    # sign out from API(eg. POST /oauth/revoke?token=xxx)
    def self.sign_out_by_guid!(guid)
      s = guid.presence && find_by(guid: guid)
      return if s.nil?

      s.sign_out!
    end

    def self.from_cookie(cookies)
      guid = cookies[Doorkeeper::SSO.cookie_name]
      return nil if guid.blank?

      find_by(guid: guid)
    end

    private

    def set_guid
      self.guid ||= SecureRandom.uuid
    end
  end
end
