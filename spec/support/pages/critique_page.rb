require 'support/base_page'

class CritiquePage < BasePage
  def open
    visit beats_path
    self
  end

  def open_modal(id)
    first("a[href='/critiques/#{id}']").trigger :click
  end

  def click_beat_avatar
    first('img.avatar').trigger :click
  end

  def close_modal
    find('#lazy_close').trigger :click
  end

  def click_oldest_newest_order
     page.execute_script("$('select#critiques_order').val('old').change();")
  end

  def open_html_critique(track_id)
    visit critique_path(track_id)
  end
end
