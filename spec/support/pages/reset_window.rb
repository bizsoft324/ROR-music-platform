require 'support/base_page.rb'

class ResetWindow < BasePage
  def open
    visit home_index_path
    self
  end

  def forgot_password
    find('a[href="/signin"]', visible: false).trigger :click
    wait_js_execution
    find('a[href="/password_resets/new"]').trigger :click
  end

  def update_password(user)
    visit edit_password_reset_path(user, password_reset_token: user.password_reset_token)
    self
  end
end
