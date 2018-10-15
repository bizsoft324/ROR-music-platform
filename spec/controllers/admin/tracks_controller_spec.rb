require 'rails_helper'

RSpec.describe Admin::TracksController, type: :controller do
  describe '#index' do
    it 'responds successfully' do
      get :index, format: :json
      expect(response).to be_successful
    end
  end

  describe 'destroy' do
    it 'deletes Comment and redirects' do
      track = create(:track)
      expect { delete :destroy, id: track.id }.to change { Track.count }.by(-1)
      response.should redirect_to admin_tracks_path
    end
  end
end
