require 'rails_helper'

describe Doorkeeper::SSO do
  it { should be_a Module }
  it { should respond_to :cookie_name }
  it { should respond_to :cookie_name= }
  it { expect(subject.cookie_name).to eq('_dummy_sso_session_guid') }
end
