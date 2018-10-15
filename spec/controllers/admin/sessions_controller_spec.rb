require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :controller do
  let(:admin_user) { create(:mock_user, roles: :admin) }
  let(:non_admin_user) { create(:mock_user, roles: nil) }
  describe '#new' do
    it 'assignes @admin_session' do
      get :new
      expect(assigns(:admin_session)).to be_an_instance_of(Session)
    end
  end

  describe '#create valid' do
    it 'creates a valid session and redirects to dashboard' do
      post :create, params: { session: { email_or_username: admin_user.email, password: admin_user.password } }
      expect(assigns(:admin_session)).to be_valid
      expect(session[:admin]).to eq(true)
      expect(response).to redirect_to admin_dashboards_path
    end
  end

  describe '#create invalid' do
    it 'redirects to new' do
      post :create, params: { session: { email_or_username: non_admin_user.email, password: non_admin_user.password } }
      expect(response).to render_template(:new)
    end
  end
end
