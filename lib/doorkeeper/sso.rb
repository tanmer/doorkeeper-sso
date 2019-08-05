ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'SSO'
end

require 'doorkeeper'
require "doorkeeper/sso/engine"

module Doorkeeper
  module SSO
    mattr_accessor :cookie_name
    mattr_accessor :on_signed_in, default: ->(_) {}
    mattr_accessor :on_signed_out, default: ->(_) {}
  end
end
