require 'rails_helper'

feature 'Sign in' do
  let(:sign_in_window) { SignInWindow.new }
  let(:invalid_email) { 'user@example' }
  let(:valid_email) { 'user@example.com' }
  let(:password) { '123456789' }

  before { create(:track) }

  describe 'social' do
    let(:params) do
      { page_2: { city: 'New York' },
        page_3: { password: password, password_confirmation: password, email: invalid_email } }
    end

    before do
      allow_any_instance_of(SoundCloud::Client).to receive(:authorize_url).and_return(auth_callbacks_path(:soundcloud))
      allow_any_instance_of(SoundCloudService).to receive(:soundcloud_session).and_return(mock_soundcloud_identity_params)
      allow_any_instance_of(SoundCloudService).to receive(:soundcloud_user).and_return(mock_soundcloud_user_params)
    end

    scenario 'Twitter', js: true do
      sign_in_window.open
      mock_auth_hash
      sign_in_window.open_form_of_choice
      sign_in_window.wait_js_execution
      sign_in_window.twitter_sign_in
      sign_in_window.wait_js_execution
      expect(page.current_path).to eq beats_path
      within '#lazybox' do
        expect(page).to have_content('TWITTER AUTHORIZED')
        # page 1
        expect(page).to have_content('Keep twitter username or type a new one')
        expect(page).to have_selector('i.uk-icon-twitter')
        expect(page).to have_field('user[username]', with: 'JohnSmith')
        sign_in_window.click_next
        sign_in_window.wait_js_execution
        # page 2
        expect(page).to have_field('user[city]', visible: false)
        expect(page).to have_select('user[country]', selected: 'United States')
        sign_in_window.set_attributes(params[:page_2])
        sign_in_window.click_next
        sign_in_window.wait_js_execution
        # page 3
        expect(page).to have_field('user[email]')
        expect(page).to have_no_css('.error', text: 'IS INVALID')
        expect(page).to have_field('user[password]')
        expect(page).to have_field('user[password_confirmation]')
        sign_in_window.set_attributes(params[:page_3])
        sign_in_window.click_next
        sign_in_window.wait_js_execution
        # show page 3 with error
        expect(page).to have_field('user[email]')
        expect(page).to have_css('.parsley-type', text: 'This value should be a valid email.')
        sign_in_window.set_attributes(params[:page_3].merge!(email: valid_email))
        expect(page).to have_no_css('.parsley-type', text: 'This value should be a valid email.')
        sign_in_window.click_next
        sign_in_window.wait_js_execution
        # page 4
        expect(page).to have_field('user[avatar]', visible: false)
        sign_in_window.change_avatar
        sign_in_window.click_next
        sign_in_window.wait_js_execution
      end
      expect(page.current_path).to eq new_track_path
    end

    # hide until fix import from soundcloud
    # scenario 'SoundCloud', js: true do
    #   sign_in_window.open
    #   sign_in_window.open_form_of_choice
    #   sign_in_window.wait_js_execution
    #   sign_in_window.soundcloud_sign_in
    #   sign_in_window.wait_js_execution
    #   expect(page.current_path).to eq '/'
    #   within '#lazybox' do
    #     expect(page).to have_content('SOUNDCLOUD AUTHORIZED')
    #     # page 1
    #     expect(page).to have_field count: 1
    #     expect(page).to have_content('Keep soundcloud username or type a new one')
    #     expect(page).to have_selector('i.uk-icon-soundcloud')
    #     expect(page).to have_field('user[username]', with: 'JohnSmith')
    #     sign_in_window.click_next
    #     sign_in_window.wait_js_execution
    #     # page 2
    #     expect(page).to have_field('user[city]', visible: false)
    #     expect(page).to have_select('user[country]', selected: 'United States')
    #     sign_in_window.set_attributes(params[:page_2])
    #     sign_in_window.click_next
    #     sign_in_window.wait_js_execution
    #     # page 3
    #     expect(page).to have_field('user[email]')
    #     expect(page).to have_field('user[password]')
    #     expect(page).to have_field('user[password_confirmation]')
    #     sign_in_window.set_attributes(params[:page_3])
    #     sign_in_window.click_next
    #     sign_in_window.wait_js_execution
    #     # show page 3 with error
    #     expect(page).to have_field('user[email]')
    #     expect(page).to have_css('.parsley-type', text: 'This value should be a valid email.')
    #     sign_in_window.set_attributes(params[:page_3].merge!(email: valid_email))
    #     expect(page).to have_no_css('.parsley-type', text: 'This value should be a valid email.')
    #     sign_in_window.click_next
    #     sign_in_window.wait_js_execution
    #     # page 4
    #     expect(page).to have_field('user[avatar]', visible: false)
    #     sign_in_window.change_avatar
    #     sign_in_window.click_next
    #     sign_in_window.wait_js_execution
    #   end
    #   expect(page.current_path).to eq new_track_path
    # end

    # context 'username witout name' do
    #   before do
    #     allow_any_instance_of(SoundCloudService).to receive(:soundcloud_user).and_return(mock_soundcloud_user_params_without_name)
    #   end

    #   scenario 'SoundCloud', js: true do
    #     sign_in_window.open
    #     sign_in_window.open_form_of_choice
    #     sign_in_window.wait_js_execution
    #     sign_in_window.soundcloud_sign_in
    #     sign_in_window.wait_js_execution
    #     expect(page.current_path).to eq '/'
    #     within '#lazybox' do
    #       expect(page).to have_content('SOUNDCLOUD AUTHORIZED')
    #       expect(page).to have_field count: 3
    #       expect(page).to have_content('Keep soundcloud username or type a new one')
    #       expect(page).to have_selector('i.uk-icon-soundcloud')
    #       expect(page).to have_field('user[username]', with: 'JohnSmith')
    #       sign_in_window.click_next
    #       sign_in_window.wait_js_execution
    #       expect(page).to have_content('Please enter a first name')
    #       expect(page).to have_content('Please enter a last name')
    #       expect(page).to have_field('user[first_name]', with: '')
    #       expect(page).to have_field('user[last_name]', with: '')
    #       expect(page).to have_content('Please enter a first name')
    #       expect(page).to have_content('Please enter a last name')
    #     end
    #   end
    # end
  end

  describe 'form new session' do
    let(:valid_params) { { email_or_username: valid_email, password: password } }
    let(:invalid_params) { { email_or_username: invalid_email, password: password } }
    let!(:user) { create(:user, email: valid_email, password: password) }

    before { allow_any_instance_of(ApplicationController).to receive(:slack_notify).and_return(true) }

    scenario 'email or username', js: true do
      sign_in_window.open
      sign_in_window.email_sign_in
      sign_in_window.wait_js_execution
      expect(page).to have_selector('form#new_session')
      expect(page).to have_no_css('.error')
      expect(page).to have_field('session[email_or_username]')
      expect(page).to have_css("input#session_email_or_username[placeholder='Email or username']")
      expect(page).to have_field('session[password]')
      expect(page).to have_css("input#session_password[placeholder='Password']")
      sign_in_window.set_attributes(invalid_params, 'session')
      sign_in_window.submit_form
      sign_in_window.wait_js_execution
      expect(page).to have_css('.error')
      sign_in_window.set_attributes(valid_params, 'session')
      sign_in_window.submit_form
      expect(page).to have_no_selector('form#new_session')
    end
  end

  describe 'password reset' do
    let!(:user) { create(:user, email: valid_email) }
    let(:unregistered_email) { 'other@example.com' }

    scenario 'form for email', js: true do
      sign_in_window.open
      sign_in_window.email_sign_in
      sign_in_window.wait_js_execution
      sign_in_window.forgot_password
      sign_in_window.wait_js_execution
      expect(page).to have_selector('form#password_reset')
      expect(page).to have_no_css('.parsley-errors-list li')
      expect(page).to have_field('[email]')
      expect(page).to have_css("input#_email[placeholder='Email']")
      expect(page).to have_css('span.error', text: '')
      sign_in_window.submit_form
      sign_in_window.wait_js_execution
      expect(page).to have_css('.parsley-errors-list li', text: 'EMAIL REQUIRED')
      sign_in_window.set_attributes({ email: invalid_email }, '')
      expect(page).to have_css('.parsley-errors-list li', text: 'THIS VALUE SHOULD BE A VALID EMAIL.')
      sign_in_window.set_attributes({ email: unregistered_email }, '')
      expect(page).to have_no_css('.parsley-errors-list li')
      sign_in_window.submit_form
      sign_in_window.wait_js_execution
      expect(page).to have_css('span.error', text: 'PLEASE TRY AGAIN WITH OTHER INFORMATION')
      sign_in_window.set_attributes({ email: valid_email }, '')
      sign_in_window.submit_form
      sign_in_window.wait_js_execution
      expect(page).to have_no_selector('#lazybox')
      expect(page).to have_content('Email has been sent')
    end
  end
end
