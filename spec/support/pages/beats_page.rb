require 'support/base_page'

class BeatsPage < BasePage
  def open
    visit beats_path
    self
  end

  def click_rating(icon_id)
    page.find(icon_id).trigger :click
  end

  def click_label(label)
    find(label).trigger :click
  end

  def click_label(label)
    find(label).trigger :click
  end
end
