class BasePage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def initialize(path = root_path)
    @path = path
  end

  def open
    visit @path
    self
  end

  def wait_js_execution
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
