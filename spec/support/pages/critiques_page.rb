require 'support/base_page'

class CritiquesPage < BasePage
  def open
    visit critiques_path
    self
  end

  def show_given_critiques
    find('a', text: 'CRITIQUES GIVEN').trigger :click
  end

  def show_received_critiques
    find('a', text: 'CRITIQUES RECEIVED').trigger :click
  end
end
