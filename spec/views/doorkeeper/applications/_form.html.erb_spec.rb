require 'rails_helper'

describe "doorkeeper/applications/_form.html.erb" do
  it "displays all the widgets" do
    render partial: 'doorkeeper/applications/form.html.erb',
          locals: { application: Doorkeeper::Application.new }

    expect(rendered).to include('<input name="doorkeeper_application[sso]"')
    expect(rendered).not_to include('translation missing: en.doorkeeper.applications.help.sso')
  end
end
