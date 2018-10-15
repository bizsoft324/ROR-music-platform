require 'rails_helper'

feature 'Navigation' do
  let!(:user) { create(:user) }
  let(:navigation) { Navigation.new }
  let(:slack) { double(ping: true) }
  let(:admin) { create(:user, roles: :admin) }

  before do
    create(:track, user: user)
    cookies = { auth_token: user.auth_token, permanent: { auth_token: user.auth_token } }
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(Slack::Notifier).to receive(:new).and_return(slack)
  end

  scenario 'dropdown', js: true do
    navigation.open
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    navigation.wait_js_execution
    expect(page).to have_css('.dropdown__content')
    expect(page).to have_css('a', text: 'PROFILE')
    expect(page).to have_css('a', text: 'MY ARTIST PAGE')
    expect(page).to have_css('a', text: 'SIGN OUT')
    # expect(page).to have_css('a', text: 'Legal')
    # expect(page).to have_css('a', text: 'Copyright')
    # expect(page).to have_css('a', text: 'Help')
    expect(page).to have_content(user.name)
    navigation.dropdown_close
    navigation.wait_js_execution
    expect(page).to have_no_css('.dropdown__content')
  end

  scenario 'signout' do
    navigation.open
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    navigation.wait_js_execution
    expect(page).to have_css('.dropdown__content')
    expect(page).to have_no_css("a[href='/signup']")
    navigation.signout
    navigation.wait_js_execution
    expect(page).to have_no_css('.dropdown__content')
  end

  scenario 'open profile', js: true do
    navigation.open
    expect(page.current_path).to eq beats_path
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    navigation.wait_js_execution
    expect(page).to have_css('.dropdown__content')
    navigation.open_profile
    navigation.wait_js_execution
    expect(page).to have_content 'PROFILE'
  end
end
