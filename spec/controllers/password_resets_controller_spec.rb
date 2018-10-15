require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create(:mock_user) }
  describe '#create' do
    it 'make a call to :send_password_reset' do
      allow_any_instance_of(User).to receive(:send_password_reset).and_return(true)
      post :create, email: user.email, format: :js
      expect(assigns(:user)).to have_received(:send_password_reset)
    end
  end

  describe '#update' do
    it 'will not update if reset is > 12 hrs old' do
      allow_any_instance_of(User).to receive(:password_reset_sent_at).and_return(13.hours.ago)
      put :update, id: user.id
      expect(subject).to redirect_to :root
    end

    it 'updates password' do
      allow_any_instance_of(User).to receive(:password_reset_sent_at).and_return(4.hours.ago)
      put :update, id: user.id, user: { password: '12345678', password_confirmation: '12345678' }
      expect(subject).to redirect_to :root
      expect(assigns(:user).password).to eq('12345678')
      expect(assigns(:user).password_confirmation).to eq('12345678')
    end
  end

  describe '#edit' do
    it 'finds user by password_reset_token' do
      user.update!(password_reset_token: '12345678')
      get :edit, id: user.id, password_reset_token: '12345678'
      expect(assigns(:user)).to eq(user)
      expect(subject).to render_template(:edit)
    end
  end
end
