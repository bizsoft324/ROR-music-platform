require 'support/base_page'

class SignInWindow < BasePage
  def open
    visit beats_path
    self
  end

  def email_sign_in
    find("a[href='/signin']", visible: false, match: :first).trigger :click
  end

  def forgot_password
    find("a[href='/password_resets/new']", text: 'Forgot Password?').trigger :click
  end

  def twitter_sign_in
    find('a.button.social.twitter').trigger :click
  end

  def soundcloud_sign_in
    find('a.button.social.soundcloud').trigger :click
  end

  def open_sign_up_form
    open_form_of_choice
    find('a.button.email').trigger :click
  end

  def click_next_sign_up_form
    find('a.next-form').trigger :click
  end

  def agree_to_terms
    find('label.toggle-label').trigger :click
  end

  def submit_form
    find("button.btn[type='submit']").trigger :click
  end

  def click_next
    find('.next.tw-next').trigger :click
  end

  def set_attributes(attributes = {}, name_form = 'user')
    attributes.each do |attr, value|
      fill_in "#{name_form}[#{attr}]", with: value
    end
  end

  def open_form_of_choice
    find("#desktop-navigation a[href='/signup']", visible: false).trigger :click
  end

  def change_avatar
    find('label[for="inputFile"]', visible: false).trigger :click
    attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/images/artofcool.jpg", visible: false)
  end
end
