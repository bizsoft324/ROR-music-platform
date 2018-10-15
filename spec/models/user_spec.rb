require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:tracks) }
    it { is_expected.to have_many(:ratings) }
    it { is_expected.to have_many(:identities) }
    it { is_expected.to have_many(:badges) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(4) }

    context 'validate email' do
      it { is_expected.to allow_value('user@example.com').for(:email) }
      it { is_expected.not_to allow_value('user.com').for(:email) }
      it { is_expected.not_to allow_value('user@foo').for(:email) }
    end

    context 'validate username' do
      it { is_expected.to allow_value('user.example').for(:username) }
      it { is_expected.to allow_value('user_example').for(:username) }
      it { is_expected.to allow_value('user-example').for(:username) }
      it { is_expected.not_to allow_value('user example').for(:username) }
      it { is_expected.not_to allow_value('user@foo').for(:username) }
      it { is_expected.not_to allow_value('_user').for(:username) }
      it { is_expected.not_to allow_value('1user').for(:username) }
    end

    context 'not validate password for created user' do
      let!(:user) { create(:user) }
      subject { User.first }

      it do
        subject.username = Faker::Internet.user_name(4)
        subject.valid?
        expect(subject.valid?).to eq true
      end
    end
  end

  describe 'callbacks' do
    context 'send confirm email after update email' do
      let(:user) { create(:user, confirmed: true) }
      subject { -> { user.update(email: 'new_email@example.com') } }

      it do
        subject.call
        expect(user.confirmed).to eq false
      end

      it { expect { subject.call }.to have_enqueued_job.exactly(1).on_queue('mailers') }

      it 'sends email' do
        expect do
          perform_enqueued_jobs do
            subject.call
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context 'set default avatar' do
      let(:user) { build(:user) }
      subject { -> { user.save } }

      it do
        expect(user[:avatar].present?).to eq false
        subject.call
        expect(user[:avatar].present?).to eq true
      end
    end
  end

  describe 'methods' do
    let!(:user) { create(:user, email: 'user@example.com') }
    let(:new_user) { build(:user, email: 'user@example.com', password: nil) }

    it 'check_uniq_email' do
      expect(new_user.email).to eq 'user@example.com'
      new_user.check_uniq_email
      expect(new_user.email).to eq nil
    end

    it 'missing_password?' do
      expect(new_user.missing_password?).to eq true
      new_user.update(password: '123456789')
      expect(new_user.missing_password?).to eq false
    end

    context 'send_password_reset' do
      subject { -> { user.send_password_reset } }

      it 'change field' do
        expect(user.password_reset_sent_at).to eq nil
        expect(user.password_reset_token).to eq nil
        subject.call
        expect(user.password_reset_sent_at).to be
        expect(user.password_reset_token).to be
      end

      it 'enqueues email' do
        expect { subject.call }.to have_enqueued_job.exactly(1).on_queue('mailers')
      end

      it 'sends email' do
        expect do
          perform_enqueued_jobs do
            subject.call
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context 'send_daily_emails' do
      it 'enqueues emails at 9am' do
        email_data = { 'this is track title 1' => { 'Day' => { 'position' => 3 }, 'top_ten' => true }, 'this is track title 2' => { 'Week' => { 'position' => 4 }, 'top_ten' => true } }
        @user = create(:user, email_data: email_data)
        expect { @user.send_daily_emails }.to_not have_enqueued_job.on_queue('mailers')
        Timecop.freeze('Wed, 11 Jan 2017 9:48:26 EST -05:00')
        expect { @user.send_daily_emails }.to have_enqueued_job.exactly(1).on_queue('mailers')
        Timecop.return
      end

      it 'sends email' do
        email_data = { 'this is track title 1' => { 'Day' => { 'position' => 3 }, 'top_ten' => true }, 'this is track title 2' => { 'Week' => { 'position' => 4 }, 'top_ten' => true } }
        @user = create(:user, email_data: email_data)
        Timecop.freeze('Wed, 11 Jan 2017 9:48:26 EST -05:00')
        expect do
          perform_enqueued_jobs do
            @user.send_daily_emails
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        Timecop.return
      end
    end
  end
end
