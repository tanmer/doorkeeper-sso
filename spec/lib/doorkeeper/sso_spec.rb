require 'rails_helper'

describe Doorkeeper::SSO do
  it { should be_a Module }
  it { should respond_to :cookie_name }
  it { should respond_to :cookie_name= }
  it { expect(subject.cookie_name).to eq('_dummy_sso_session_guid') }

  it { should respond_to :on_signed_in }
  it { should respond_to :on_signed_in= }
  it { expect(subject.on_signed_in).to be_a Proc }

  it { should respond_to :on_signed_out }
  it { should respond_to :on_signed_out= }
  it { expect(subject.on_signed_out).to be_a Proc }
end
