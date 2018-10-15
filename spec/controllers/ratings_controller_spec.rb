require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { create(:mock_user) }
  let(:track) { create(:track, user: user) }
  let(:slack) { double(ping: true) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(Slack::Notifier).to receive(:new).and_return(slack)
  end

  describe '#create_or_update' do
    context 'user has not rated track' do
      it 'creates new rating' do
        expect(user.ratings).to be_empty
        expect do
          post :create_or_update,
               user_id: user.id,
               track: track,
               star: 'like'
        end.to change(Rating, :count).by(1)
      end
    end

    context 'user has rated track' do
      it 'updates current rating' do
        @rating = Rating.create!(user_id: user.id, track: track, status: :like)
        expect do
          post :create_or_update,
               user_id: user.id,
               track: track,
               star: 'dislike'
          @rating.reload
        end.to change(Rating, :count).by(0)
        expect(@rating.status).to eq('dislike')
        # expect(Rating.count).to eq(1)
      end
    end

    context 'either case' do
      it 'responds with proper json' do
        rating_count = { 'likes' => 1, 'dislikes' => 0, 'indifference' => 0, 'star' => 'like' }
        post :create_or_update,
             user_id: user.id,
             track: track,
             star: 'like'

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq(rating_count)
      end
    end
  end
end
