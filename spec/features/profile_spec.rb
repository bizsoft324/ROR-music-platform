require 'rails_helper'

feature 'Profile' do
  let(:new_name) { 'John' }
  let(:profile_page) { ProfilePage.new }

  before { create(:track) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'valid user' do
    let!(:user) { create(:user) }
    let(:valid_params) { { first_name: new_name } }
    let(:invalid_params) { { first_name: '' } }

    scenario 'Update user profile', js: true do
      profile_page.open
      profile_page.wait_js_execution
      expect(page).to have_content('PROFILE')
      expect(page).to have_field('user[avatar]', visible: false)
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.city)
      expect(page).to have_select('user[country]', selected: translation_country(user.country), visible: false)
      profile_page.change_avatar
      profile_page.wait_js_execution
      profile_page.change_profile(invalid_params)
      expect(page).to have_content('Please correct the following 1 error.')
      expect(page).to have_content('First name can\'t be blank')
      profile_page.change_profile(valid_params)
      expect(page).to have_css('.toast-message')
    end

    scenario 'Update avatar' do
      profile_page.open
      profile_page.wait_js_execution
      profile_page.change_avatar
      profile_page.wait_js_execution
      profile_page.change_profile(valid_params)
      profile_page.open
      expect(page).to have_selector("img[src*='res.cloudinary.com']")
    end

    scenario 'Update email', js: true do
      profile_page.open
      profile_page.wait_js_execution
      profile_page.open_settings
      profile_page.wait_js_execution
      expect(page).to have_selector("input[value='#{user.email}']")
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')
      fill_in 'user[email]', with: 'user@example'
      expect(page).to have_selector('li.parsley-type', text: 'This value should be a valid email.')
      fill_in 'user[email]', with: 'user@example.com'
      expect(page).to have_no_selector('li.parsley-type', text: 'This value should be a valid email.')
      profile_page.update_email
      expect(page).to have_no_selector('#lazybox')
      expect(user.email).to eq 'user@example.com'
    end

    scenario 'Update password', js: true do
      profile_page.open
      profile_page.wait_js_execution
      profile_page.open_settings
      profile_page.wait_js_execution
      expect(page).to have_selector("input[value='#{user.email}']")
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')
      fill_in 'user[password]', with: '123456'
      profile_page.update_password
      expect(page).to have_selector('li.parsley-minlength', text: 'This value is too short. It should have 8 characters or more.')
      expect(page).to have_selector('li.parsley-required', text: 'This value is required.')
      fill_in 'user[password]', with: '12345678'
      fill_in 'user[password_confirmation]', with: '123456'
      expect(page).to have_selector('li.parsley-equalto', text: 'This value should be the same.')
      expect(page).to have_no_selector('li.parsley-minlength', text: 'This value is too short. It should have 8 characters or more.')
      fill_in 'user[password_confirmation]', with: '12345678'
      expect(page).to have_no_selector('li.parsley-equalto', text: 'This value should be the same.')
      profile_page.update_password
      profile_page.wait_js_execution
      expect(page).to have_no_selector('#lazybox')
    end
  end

  def translation_country(country)
    ISO3166::Country[country].translations[I18n.locale.to_s]
  end
end
