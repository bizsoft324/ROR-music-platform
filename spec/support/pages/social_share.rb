require 'support/base_page'

class SocialShare < BasePage
  def open
    visit '/beats'
    self
  end

  def open_modal
    find('#share-link').trigger :click
  end

  def close_modal
    find('#social-share-close').trigger :click
  end
end
