require 'rails_helper'

RSpec.describe CritiquesController, type: :controller do
  let(:user_1) { create(:mock_user) }
  let(:user_2) { create(:mock_user) }
  let(:track_1) { create(:track, user: user_1) }
  let(:track_2) { create(:track, user: user_2) }
  let(:comment_1) { Comment.create(user_id: user_1.id, body: 'this is comment body for comment_1', commentable_id: track_2.id, critique_id: 2) }
  let(:comment_2) { Comment.create(user_id: user_2.id, body: 'this is comment body for comment 2', commentable_id: track_1.id, critique_id: 3) }

  subject { response }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user_1)
  end

  describe '#index' do
    before do
      get :index
    end

    it { is_expected.to have_http_status(:ok) }
  end
  # describe '#show' do
  #   it 'responds correctly' do
  #     get :show, track_id: @track.id
  #     expect(response).to be_success
  #   end

  #   context 'filter set old to new' do
  #     it 'assigns proper instance variables' do
  #       get :show, track_id: @track.id, sort: 'old'
  #       expect(assigns(:track)).to eq(@track)
  #       expect(assigns(:comments)).to eq([@comment_1, @comment_2])
  #     end
  #   end
  #   context 'filter new to old' do
  #     it 'assigns proper instance variables' do
  #       get :show, track_id: @track.id, sort: 'new'
  #       expect(assigns(:track)).to eq(@track)
  #       expect(assigns(:comments)).to eq([@comment_2, @comment_1])
  #     end
  #   end
  # end
end

# **********************************
# will have to rewrite as feature specs for modal
# **********************************
