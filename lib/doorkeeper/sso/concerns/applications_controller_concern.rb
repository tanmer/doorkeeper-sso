module Doorkeeper::SSO::Concerns
  module ApplicationsControllerConcern
    def application_params
      super.merge(params.require(:doorkeeper_application).permit(:sso))
    end
  end
end
