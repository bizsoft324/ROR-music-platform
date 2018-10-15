require 'support/base_page'

class ProfilePage < BasePage
  def open
    visit beats_path
    first("a[href='/profile']", visible: false).trigger :click
    self
  end

  def change_url
    visit beats_path
  end

  def change_profile(attributes = [])
    attributes.each do |attr, value|
      find('span[data-attr="first_name"]').set(value)
    end
    find("input.profile__save[type='submit']").trigger :click
  end

  def change_avatar
    find('.profile__edit').trigger :click
    attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/images/artofcool.jpg", visible: false)
  end

  def open_settings
    find('label[for="settings"]').trigger :click
  end

  def update_email
    find('input[value="Update email"]').trigger :click
  end

  def update_password
    find('input[value="Update password"]').trigger :click
  end
end
