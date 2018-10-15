require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe '#index' do
    it 'responds successfully' do
      get :index, format: :json
      expect(response).to be_successful
    end
  end

  describe 'destroy' do
    it 'deletes Comment and redirects' do
      user = create(:user)
      expect { delete :destroy, id: user.id }.to change { User.count }.by(-1)
      response.should redirect_to admin_users_path
    end
  end
end
