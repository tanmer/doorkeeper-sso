require 'rails_helper'
describe Doorkeeper::SSO::Engine do
  subject { Doorkeeper::SSO::Engine }
  it { should be_isolated }

  describe "doorkeeper-sso.feature initializer" do
    subject { Doorkeeper::SSO::Engine.initializers.find{|x| x.name == 'doorkeeper-sso.feature'} }
    it { should_not be_nil }
    it { expect(subject.after).to eq('doorkeeper.helpers') }
  end
end
