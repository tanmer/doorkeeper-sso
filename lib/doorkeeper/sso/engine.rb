module Doorkeeper
  module SSO
    class Engine < ::Rails::Engine
      isolate_namespace Doorkeeper::SSO

      config.before_initialize do
        app_name = ::Rails.application.class.name.split("::").first.underscore
        Doorkeeper::SSO.cookie_name = "_#{app_name}_sso_session_guid"
      end

      initializer 'doorkeeper-sso.feature', after: 'doorkeeper.helpers' do
        require 'doorkeeper/sso/concerns/authorizations_controller_concern'
        require 'doorkeeper/sso/concerns/tokens_controller_concern'
        Doorkeeper::AuthorizationsController.prepend Doorkeeper::SSO::Concerns::AuthorizationsControllerConcern
        Doorkeeper::TokensController.prepend Doorkeeper::SSO::Concerns::TokensControllerConcern
      end
    end
  end
end
