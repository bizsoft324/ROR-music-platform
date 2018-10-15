# require 'rails_helper'
#
# feature 'AdminSession' do
#   let(:valid_params) { { email: Rails.application.secrets.admin_username, password: Rails.application.secrets.admin_password } }
#   let(:invalid_params) { { email: Rails.application.secrets.admin_username, password: '' } }
#   let(:login_page) { Admin::LoginPage.new }
#
#   scenario 'Log In/Log Out Admin Panel' do
#     login_page.open
#     login_page.login(invalid_params)
#     expect(page).to have_css('.error')
#     login_page.login(valid_params)
#     expect(page).to have_no_css('.error')
#   end
#
#   scenario 'Does not login with Invalid Params' do
#     @login_page = Admin::LoginPage.new
#     @invalid_user = build(:invalid_user)
#     @invalid_params = {
#       email: @invalid_user.email.to_s,
#       password: @invalid_user.password.to_s
#     }
#     @login_page.open
#     @login_page.login(@invalid_params)
#     expect(page).to have_css('.error')
#   end
#
#   scenario 'Logs In with Valid Params' do
#     @login_page = Admin::LoginPage.new
#     @user = create(:mock_user, roles: 'admin')
#     p @user
#     @params = {
#       email: @user.email.to_s,
#       password: @user.password.to_s
#     }
#     p @params
#     @login_page.open
#     @login_page.login(@params)
#     screenshot_and_open_image # ?
#     expect(page).to have_content('This is dashboard')
#   end
# end
