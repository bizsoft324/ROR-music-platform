require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user)  { create(:mock_user) }
  let(:user2) { create(:mock_user) }
  let(:track) { create(:track, user: user) }

  describe 'Associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
    it { should belong_to(:critique) }
    it { should have_many(:soundbites) }
  end

  describe 'validations of body' do
    it 'has body > 1 character' do
      @comment = create_comment(40)
      expect(@comment).to be_valid
    end

    it 'has no body' do
      @comment = create_comment(0)
      expect(@comment).to_not be_valid
    end

    it 'has no user' do
      @comment = create_comment(200)
      @comment.user_id = nil
      expect(@comment).to_not be_valid
    end
  end

  describe 'parrent_critique?' do
    before do
      @comment = create_comment(200)
    end
    it 'returns true if parent_id is nil and user_id does not equal Track.user' do
      @comment.parent_id = nil
      expect(@comment.parent_critique?).to be(true)
    end

    it 'returns false if parent_id is not nil and user_id does not equal Track.user' do
      @comment.parent_id = Random.rand(200)
      expect(@comment.parent_critique?).to be(false)
    end

    it 'returns false if parent_id is nil and user_id equals Track.user' do
      @comment.user_id = user.id
      expect(@comment.parent_critique?).to be(false)
    end
  end

  describe '.root_elements' do
    it 'return roots elements' do
      comments = create_list(:comment, 3,
                             commentable_id: track.id,
                             commentable_type: 'Track',
                             user_id: user2.id,
                             body: random_string(200))

      results = Comment.root_elements
      expect(results).to eq comments
    end
  end

  describe 'return recent and old comments' do
    let!(:previous_comment) do
      create :comment, commentable_id: track.id, commentable_type: 'Track', user_id: user2.id,
                       body: random_string(200), created_at: Date.parse((Time.now - 2 * 24 * 60 * 60).strftime('%Y-%m-%d'))
    end

    let!(:today_comment) do
      create :comment, commentable_id: track.id, commentable_type: 'Track', user_id: user2.id,
                       body: random_string(200), created_at: Date.today
    end

    it 'return recent comments' do
      results = Comment.recent

      expect(results.first).to eq today_comment
      expect(results.last).to eq previous_comment
    end

    it 'return old comments' do
      results = Comment.old

      expect(results.last).to eq today_comment
      expect(results.first).to eq previous_comment
    end
  end
end

def create_comment(body_length)
  body = random_string(body_length)
  build(
    :comment,
    commentable_id: track.id,
    user_id: user2.id,
    body: body,
    parent_id: nil
  )
end
