require 'rails_helper'

feature 'Social Share' do
  let(:social_share) { SocialShare.new }

  before do
    create(:track, artist_type_id: create(:artist_type).id)
  end

  scenario 'modal', js: true do
    social_share.open
    expect(page).to have_no_css('.modal-social')
    social_share.open_modal
    expect(page).to have_css('.modal-social')
    expect(page).to have_css('.twitter')
    expect(page).to have_css('.facebook')
    expect(page).to have_css('.tumblr')
    expect(page).to have_css('.googleplus')
    expect(page).to have_css('.email')
    expect(page).to have_css('#social-share-close')
    social_share.close_modal
    social_share.wait_js_execution
    expect(page).to have_no_css('.modal-social')
  end
end
