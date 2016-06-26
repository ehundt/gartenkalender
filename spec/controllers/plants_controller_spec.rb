require 'rails_helper'

RSpec.describe PlantsController do
  login_user

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).not_to be_nil
  end

  describe 'GET #new' do
    subject { get :new }

    it "renders the new template" do
      expect(response).to have_http_status(200)
      expect(subject).to render_template :new
    end
  end

  describe 'GET #show' do
    it "chooses the correct plant" do
      plant = FactoryGirl.create(:plant)
      get :show, id: plant.id
      expect(assigns(:plant)).to eql plant
    end
  end
end
