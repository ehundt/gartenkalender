require 'rails_helper'

RSpec.describe 'plants/show' do

  it "shows the name of the plant" do
    assign(:plant,        FactoryGirl.create(:plant))
    assign(:current_user, FactoryGirl.create(:user))

    render

    expect(rendered).to have_content("Erdbeere")
  end
end
