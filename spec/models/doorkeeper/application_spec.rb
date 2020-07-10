require 'rails_helper'
describe Doorkeeper::Application, type: :model do
  subject { Doorkeeper::Application.create!(name: 'example1', redirect_uri: 'urn:ietf:wg:oauth:2.0:oob') }
  it { should respond_to :is_sso }
  it { should respond_to :is_sso= }
  it('default sso be false') { should_not be_is_sso }
  it('sso set to true') { subject.update is_sso: true; should be_is_sso }
end
