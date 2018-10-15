require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email_or_username) }
    it { is_expected.to validate_presence_of(:password) }

    context 'validate credentials' do
      let(:password) { '123456789' }
      let!(:user) { create(:user, password: password) }

      context 'valid' do
        subject { described_class.new(email_or_username: user.email, password: password) }
        it { expect(subject.valid?).to eq true }
      end

      context 'invalid' do
        subject { described_class.new(email_or_username: user.username, password: '123489') }

        it do
          expect(subject.valid?).to eq false
          expect(subject.user).to eq user
          expect(subject.errors[:email_or_username]).to eq(['is invalid'])
        end
      end
    end
  end
end
