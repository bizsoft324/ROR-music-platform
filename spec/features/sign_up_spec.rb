require 'rails_helper'

feature 'Sign up' do
  let(:sign_in_window) { SignInWindow.new }

  let(:username) { 'user' }
  let(:email) { 'user@example.com' }
  let(:new_params) { { email: 'john_smith@example.com', username: 'john_smith' } }
  let(:params) do
    { page_1: { first_name: 'John', last_name: 'Smith', city: 'New York' },
      page_2: {
        invalid: { password: '1278', password_confirmation: '12345678', email: 'user@example', username: '_user' },
        valid: { password: '12345678', password_confirmation: '12345678', email: email, username: username }
      } }
  end

  before { create(:track) }

  scenario 'with frontend validations', js: true do
    sign_in_window.open
    sign_in_window.open_sign_up_form
    expect(page).to have_content('CREATE ACCOUNT')
    expect(page.current_path).to eq beats_path
    # page 1
    expect(page).to have_field('user[first_name]', with: '')
    expect(page).to have_field('user[last_name]', with: '')
    expect(page).to have_field('user[city]', with: '')
    expect(page).to have_select('user[country]', selected: 'United States')
    form_doesnt_have_errors
    sign_in_window.click_next_sign_up_form
    form_have_errors(%w[first_name last_name city agreement], true)
    sign_in_window.set_attributes(params[:page_1])
    form_have_errors(%w[agreement], true)
    expect(page).to have_unchecked_field('agree', visible: false)
    sign_in_window.agree_to_terms
    expect(page).to have_selector('.toggle-checkbox.uk-icon-check')
    expect(page).to have_checked_field('agree', visible: false)
    form_doesnt_have_errors
    sign_in_window.click_next_sign_up_form
    # page 2
    expect(page).to have_field('user[email]', with: '')
    expect(page).to have_field('user[password]', with: '')
    expect(page).to have_field('user[password_confirmation]', with: '')
    expect(page).to have_field('user[username]', with: '')
    form_doesnt_have_errors
    sign_in_window.submit_form
    form_have_errors(%w[email password password_confirmation username], true)
    sign_in_window.set_attributes(params[:page_2][:invalid])
    form_have_errors(%w[email_invalid username_invalid password_length password_doesnt_match])
    sign_in_window.set_attributes(params[:page_2][:valid])
    form_doesnt_have_errors
    sign_in_window.submit_form
    sign_in_window.wait_js_execution
    find('#lazybox').click
    sign_in_window.wait_js_execution
    expect(page.current_path).to eq '/tracks/new'
    expect(User.find_by_email(email)).to be
  end

  scenario 'with backend validations', js: true do
    create(:user, email: email, username: username)
    sign_in_window.open
    sign_in_window.open_sign_up_form
    expect(page).to have_content('CREATE ACCOUNT')
    # page 1
    sign_in_window.set_attributes(params[:page_1])
    sign_in_window.agree_to_terms
    form_doesnt_have_errors
    sign_in_window.click_next_sign_up_form
    sign_in_window.wait_js_execution
    # page 2
    sign_in_window.set_attributes(params[:page_2][:valid])
    form_doesnt_have_errors
    sign_in_window.submit_form
    form_have_backend_errors(%w[email_taken username_taken])
    sign_in_window.set_attributes(params[:page_2][:valid].merge!(new_params))
    form_doesnt_have_errors
    sign_in_window.submit_form
    sign_in_window.wait_js_execution
    find('#lazybox').click
    sign_in_window.wait_js_execution
    expect(page.current_path).to eq '/tracks/new'
    expect(User.find_by(new_params)).to be
  end

  def form_have_errors(errors, required = false)
    expect(page).to have_css('.parsley-errors-list li', count: errors.count)
    errors.each { |error| expect(page).to have_css('.parsley-errors-list li', text: (required ? "#{error.upcase.tr!('_', ' ')} REQUIRED" : error_messages[error])) }
  end

  def form_have_backend_errors(errors)
    expect(page).to have_css('span.error', count: errors.count)
    errors.each { |error| expect(page).to have_css('span.error', text: error_messages[error]) }
  end

  def form_doesnt_have_errors
    expect(page).to have_no_css('.parsley-errors-list li')
  end

  def error_messages
    { 'email_invalid' => 'THIS VALUE SHOULD BE A VALID EMAIL.',
      'username_invalid' => 'THIS VALUE SEEMS TO BE INVALID.',
      'password_length' => 'PASSWORD SHOULD HAVE MIN 8 CHARACTERS',
      'password_doesnt_match' => 'PASSWORD DOESN\'T MATCH',
      'email_taken' => 'EMAIL HAS ALREADY BEEN TAKEN',
      'username_taken' => 'USERNAME HAS ALREADY BEEN TAKEN' }
  end
end
