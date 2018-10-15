# require 'rails_helper'

# feature 'Soundcloud import' do
#   let(:user) { create(:user) }
#   let(:import_page) { SoundcloudImportPage.new }

#   before do
#     allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
#     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
#     allow_any_instance_of(SoundCloud::Client).to receive(:authorize_url).and_return(auth_callbacks_path(:soundcloud))
#     allow_any_instance_of(SoundCloudService).to receive(:connect_account).and_return(true)
#     allow_any_instance_of(SoundcloudTracksImport).to receive(:data_from_url).and_return(mock_data_file(mock_audio_url))
#     allow_any_instance_of(AudioUploader).to receive(:around_upload).and_return([])
#   end

#   describe 'Import tracks' do
#     let(:other_track) { create(:track) }
#     let(:critique) { create(:critique, track: other_track) }
#     let!(:comment) { create(:comment, user: user, critique: critique, commentable: other_track) }
#     let(:other_track_second) { create(:track) }
#     let(:critique_second) { create(:critique, track: other_track_second) }
#     let!(:comment_second) { create(:comment, user: user, critique: critique_second, commentable: other_track_second) }
#     let!(:identity) { create(:soundcloud_identity, user: user) }

#     scenario 'soundcloud', js: true do
#       import_page.open_new_track
#       expect(page).to have_content('NO BEATS')
#       reassign_client_get mock_track_collection_params
#       import_page.choose_import_track
#       expect(page.current_path).to eq soundcloud_tracks_path
#       expect(user.tracks.count).to eq 0
#       expect(page).to have_content('ONE SONG IN SOUNDCLOUD')
#       expect(page).to have_unchecked_field('import_tracks[ids][]', visible: false)
#       import_page.choose_track
#       expect(page).to have_checked_field('import_tracks[ids][]', visible: false)
#       reassign_client_get mock_track_params
#       import_page.import_track
#       reassign_client_get mock_track_collection_params
#       expect(page.current_path).to eq soundcloud_tracks_path
#       expect(user.tracks.count).to eq 1
#     end
#   end

#   def reassign_client_get(result)
#     client = double(:client, get: result, expired?: false)
#     allow(SoundCloud).to receive(:new) { client }
#   end
# end
