require 'rails_helper'

feature 'Reset Password' do
  let(:reset_window) { ResetWindow.new }
  let(:user) { create(:mock_user) }

  scenario 'forgot password', js: true do
    reset_window.open
    reset_window.forgot_password
    expect(page).to have_css('#password_reset')
  end

  scenario 'update password', js: true do
    user.update!(password_reset_token: '12345678')
    reset_window.update_password(user)
    expect(page).to have_css('.pass__form')
  end
end
