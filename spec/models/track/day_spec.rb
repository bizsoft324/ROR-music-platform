require 'rails_helper'

RSpec.describe Track::Day, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:track) }
  end

  before(:each) do
    allow_any_instance_of(Rating).to receive(:user).and_return(create(:user))
    allow_any_instance_of(User).to receive(:name).and_return('name')
  end

  describe '#chart' do
    it 'updates Track.all_time_position' do
      track1 = create(:track, like_count: 10)
      track2 = create(:track, like_count: 4)
      track3 = create(:track, like_count: 3)
      expect(track1.reload.all_time_position).to eq(nil)
      expect(track2.reload.all_time_position).to eq(nil)
      expect(track3.reload.all_time_position).to eq(nil)
      Track::Day.chart
      expect(track1.reload.all_time_position).not_to eq(nil)
      expect(track2.reload.all_time_position).not_to eq(nil)
      expect(track3.reload.all_time_position).not_to eq(nil)
    end

    it 'grants badge for first time charted' do
      precharted_track = create(:track, like_count: 10, is_charted: true)
      uncharted_track = create(:track, like_count: 4)
      expect(precharted_track.badges).to be_empty
      expect(uncharted_track.badges).to be_empty
      Track::Day.chart
      expect(precharted_track.badges).to be_empty
      expect(uncharted_track.badges).to_not be_empty
    end
    it 'processes previous positions' do
      @user = create(:user)
      @track1 = create(:track, title: 'this is track1', user_id: @user.id)
      @track2 = create(:track, title: 'this is track2', user_id: @user.id)
      8.times { |n| @track1.ratings.create!(user_id: n, status: 'like') }
      3.times { |n| @track1.ratings.create!(user_id: n + 9, status: 'dislike') }
      4.times { |n| @track2.ratings.create!(user_id: n, status: 'like') }
      Track::Day.chart
      expect(@track1.reload.previous_positions).to eq('Day' => { 'position' => 1 })
      expect(@track2.reload.previous_positions).to eq('Day' => { 'position' => 2 })
    end

    it 'processes position changes for email' do
      @user = create(:user)
      @track1 = create(:track, title: 'this is track1', user_id: @user.id)
      @track2 = create(:track, title: 'this is track2', user_id: @user.id)
      8.times { |n| @track1.ratings.create!(user_id: n, status: 'like') }
      3.times { |n| @track1.ratings.create!(user_id: n + 9, status: 'dislike') }
      4.times { |n| @track2.ratings.create!(user_id: n, status: 'like') }
      Track::Day.chart
      [@track1, @track2].each(&:reload)
      expect(Track::Charted.process_position_changes(@track1)).to eq('Day' => { 'position' => 1 }, 'top_ten' => true)
      expect(Track::Charted.process_position_changes(@track2)).to eq('Day' => { 'position' => 2 }, 'top_ten' => true)
    end
  end
end
