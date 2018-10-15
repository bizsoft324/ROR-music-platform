require 'rails_helper'

RSpec.describe Admin::CritiquesController, type: :controller do
  describe '#index' do
    it 'responds successfully' do
      get :index, format: :json
      expect(response).to be_successful
    end
  end

  describe 'destroy' do
    it 'deletes Comment and redirects' do
      Comment.skip_callback(:create, :before, :add_critique)
      Comment.skip_callback(:save, :after, :send_message)
      comment = create(:comment)
      Comment.set_callback(:create, :before, :add_critique)
      Comment.set_callback(:save, :after, :send_message)
      expect { delete :destroy, id: comment.id }.to change { Comment.count }.by(-1)
      response.should redirect_to admin_critiques_path
    end
  end
end
