require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'confirmation' do
    before(:each) do
      @user = build_stubbed(:user, first_name: 'test', last_name: 'user')
      @confirm_token = {}
      @mail = UserMailer.confirmation(@user, @confirm_token)
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['team@beatthread.com'])
    end

    it 'assigns @name' do
      expect(@mail.body.encoded).to match(@user.name)
    end
  end

  describe 'charted' do
    before(:each) do
      @user = build_stubbed(:user, username: 'test-user')
      @track = build_stubbed(:track, user_id: @user.id, title: 'test track')
      @track_charted = build_stubbed(:track_charted, track_id: @track.id, position: 1)
      allow(@track_charted).to receive(:track).and_return(@track)
      allow(@track).to receive(:user).and_return(@user)
      @mail = UserMailer.charted(@track_charted)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('Your track has made the charts!!')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['team@beatthread.com'])
    end

    it 'assigns @name' do
      expect(@mail.body.encoded).to match(@user.username)
    end
  end

  describe 'top_ten' do
    before(:each) do
      @user = build_stubbed(:user, username: 'test-user')
      @track = build_stubbed(:track, user_id: @user.id, title: 'test track')
      @track_charted = build_stubbed(:track_charted, track_id: @track.id, position: 1)
      allow(@track_charted).to receive(:track).and_return(@track)
      allow(@track).to receive(:user).and_return(@user)
      @mail = UserMailer.top_ten(@track_charted)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('Your track is in the top ten!')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['team@beatthread.com'])
    end

    it 'assigns @name' do
      expect(@mail.body.encoded).to match(@user.username)
    end
  end

  describe 'charts_update' do
    before(:each) do
      @user = create(:user, username: 'test-user')
      @track = create(:track, user_id: @user.id, title: 'test track')
      @track_charted = build_stubbed(:track_charted, track_id: @track.id, position: 1)
      allow(@track_charted).to receive(:track).and_return(@track)
      allow(@track).to receive(:user).and_return(@user)
      @mail = UserMailer.charts_update(@user.id).deliver_now
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('Your daily charts update!')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['team@beatthread.com'])
    end

    it 'assigns @name' do
      expect(@mail.body.encoded).to match(@user.username)
    end
  end

  describe 'critique_notification' do
    before(:each) do
      @user = build_stubbed(:user, username: 'commentor')
      @track = build_stubbed(:track, user_id: @user.id, title: 'test track')
      @comment = Comment.new
      allow(@comment).to receive_messages(commentable: @track, add_critique: true, send_message: true, user: @user)
      allow(@track).to receive(:user).and_return(@user)
      @mail = UserMailer.critique_notification(@comment)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eq('New beat critique!')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['team@beatthread.com'])
    end

    it 'assigns @name' do
      expect(@mail.body.encoded).to match(@user.username)
    end
  end
end
