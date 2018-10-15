require 'support/base_page'

class SoundcloudImportPage < BasePage
  def open_new_track
    visit new_track_path
    self
  end

  def open_soundcloud_tracks
    visit soundcloud_tracks_path
    self
  end

  def choose_import_track
    find("a[href='#{soundcloud_tracks_path}']").click
  end

  def choose_track
    find(".checkbox-default .toggle-label").click
  end

  def import_track
    find_button('import selected beats').click
  end

  def click_label_import_track
    find("input#beat_deficit_pop", visible: false).trigger :focus
    page.execute_script("$('.popup.popup--info').css('display', 'block')")
  end
end
