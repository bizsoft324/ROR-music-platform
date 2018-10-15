require 'rails_helper'
RSpec.describe Track, type: :model do
  let(:track1) { create(:track) }
  let(:track2) { create(:track) }
  let(:track3) { create(:track) }
  let(:track4) { create(:track) }
  let(:track5) { create(:track) }
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:artist_type) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:critiques).dependent(:destroy) }
    it { should have_many(:users).through(:comments) }
    it { should have_many(:badges).dependent(:destroy) }
    it do
      should have_many(:subgenres_genre)
        .order('subgenres.id')
        .through(:genres)
        .source(:subgenres)
    end
    it { should have_many(:track_charted).class_name('Track::Charted') }
    it { should have_many(:likes).class_name('Rating') }
    it { should have_many(:dislikes).class_name('Rating') }
    it { should have_many(:indifferents).class_name('Rating') }
    it { should have_and_belong_to_many(:genres).dependent(:destroy) }
    it { should have_and_belong_to_many(:subgenres).dependent(:destroy) }
  end

  describe 'delegates' do
    it { should delegate_method(:username).to(:user) }
  end
  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image_data) }
  end
end
