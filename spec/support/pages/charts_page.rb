require 'support/base_page'

class ChartsPage < BasePage
  def open
    visit charts_path
    self
  end
end
