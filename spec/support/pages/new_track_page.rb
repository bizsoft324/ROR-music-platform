require 'support/base_page'

class NewTrackPage < BasePage
  def open
    visit new_track_path
    self
  end

  def attach_audio
    attach_file('track[audio]', "#{Rails.root}/spec/fixtures/audio/Goldhouse.mp3", visible: false, match: :first)
    open_modal_window
  end

  def attach_image
    attach_file("track[image]", "#{Rails.root}/spec/fixtures/images/artofcool.jpg", visible: false, match: :first)
  end

  def open_modal_window
    execute_script("$('[data-upload-content]').hide();")
    execute_script("$('.beat-uploading-content').show();")
  end

  def append_subgenres_with_js
    execute_script("
      $('.subgenre-select .subgenre-option').remove()
        option = new Option('West Coast Hip-Hop', 1)
        option = new Option('Crunk', 2)
        option.className = 'subgenre-option'
        $('.subgenre-select').append option
    ")
  end
end
