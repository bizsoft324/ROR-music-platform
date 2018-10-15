require 'support/base_page'

class Navigation < BasePage
  def open
    visit beats_path
    self
  end

  def dropdown_open
    find(".dropdown").trigger('click')
    page.execute_script("$('.dropdown__content').css('opacity', 1).attr('style', 'visibility: visible !important');")
  end

  def dropdown_close
     page.execute_script("$('.dropdown__content').attr('style', '')")
  end

  def signout
    first("a[href='/signout']", visible: false).trigger :click
  end

  def open_profile
    click_link('profile')
  end
end
