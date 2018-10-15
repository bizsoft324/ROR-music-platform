require 'rails_helper'

RSpec.describe SoundbitesController, type: :controller do
  describe 'GET' do
    it 'index' do
      get :index
      expect(response).to be_success
    end

    it 'new' do
      get :new
      expect(response).to be_success
    end
  end
end

#   # def test_create
#   #   assert_difference("Soundbite.count") do
#   #     post :create, soundbite: { comment_id: soundbite.comment_id, data_end: soundbite.data_end, data_id: soundbite.data_id, data_plays: soundbite.data_plays, data_start: soundbite.data_start, data_url: soundbite.data_url, title: soundbite.title }
#   #   end
#
#   #   assert_redirected_to soundbite_path(assigns(:soundbite))
#   # end
#
#   # def test_show
#   #   get :show, id: soundbite
#   #   assert_response :success
#   # end
#
#   # def test_edit
#   #   get :edit, id: soundbite
#   #   assert_response :success
#   # end
#
#   # def test_update
#   #   put :update, id: soundbite, soundbite: { comment_id: soundbite.comment_id, data_end: soundbite.data_end, data_id: soundbite.data_id, data_plays: soundbite.data_plays, data_start: soundbite.data_start, data_url: soundbite.data_url, title: soundbite.title }
#   #   assert_redirected_to soundbite_path(assigns(:soundbite))
#   # end
#
#   # def test_destroy
#   #   assert_difference("Soundbite.count", -1) do
#   #     delete :destroy, id: soundbite
#   #   end
#
#   #   assert_redirected_to soundbites_path
#   # end
