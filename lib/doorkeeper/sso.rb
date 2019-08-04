ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'SSO'
end

require 'doorkeeper'
require "doorkeeper/sso/engine"

module Doorkeeper
  module SSO
    class << self
      attr_accessor :cookie_name
    end
  end
end
