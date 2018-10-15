require 'support/base_page'
require 'pry'

class ArtistPage < BasePage
  def open(user)
    visit artist_track_list_path(user)
    self
  end

  def click_edit_track(track_id)
    find("#beat[data-id='#{track_id}'] .editable").trigger('click')
  end

  def click_share_track(track_id)
    find("#beat[data-id='#{track_id}'] .shareable").trigger('click')
  end

  def change_track(attributes = [])
    attributes.each do |attr, value|
      fill_in "track[#{attr}]", with: value
    end
    #Fill in hidden input with a value
    find("input[name='track[tag_list]']", visible: :hidden).set(Faker::Lorem.words(2))

    click_button 'finish'
  end

  def delete_track
    click_link('delete')
  end

  def cancel_edit_track
    click_link('cancel')
  end

  def cancel_share_track
    find('#social-share-close').trigger('click')
  end

  def click_label(label)
    find(label).trigger('click')
  end
end
