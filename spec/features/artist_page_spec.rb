require 'rails_helper'

feature 'Track Uploading' do
  let!(:user) { create(:user) }
  let!(:user_second) { create(:user) }
  let(:genre) { create(:genre, name: 'Hip-Hop') }
  let(:subgenre_first) { create(:subgenre, name: 'West Coast Hip-Hop', genre: genre) }
  let(:subgenre_second) { create(:subgenre, name: 'Crunk', genre: genre) }
  let(:artist_page) { ArtistPage.new }
  let(:track_attributes) { { title: Faker::Book.title, description: Faker::Lorem.paragraph } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  context "artist doesn't have tracks" do
    scenario 'user is being redirected to uploading page', js: true do
      artist_page.open(user)
      artist_page.wait_js_execution
      expect(page.current_path).to eq(new_track_path)
    end
  end

  context 'artist has tracks' do
    let!(:track_first) do
      create(:track,
             genres: [genre],
             subgenres: [subgenre_first, subgenre_second],
             user: user)
    end
    let!(:track_second) { create(:track, user: user) }

    scenario "user's tracks", js: true do
      artist_page.open(user)
      artist_page.click_edit_track(track_first.id)
      expect(page).to have_content('2 BEATS')
      expect(current_path).to eq edit_track_path(track_first.id)
      expect(page).to have_selector('select', count: 3)
      expect(page).to have_select('track[genre_ids][]', selected: 'Hip-Hop')
      artist_page.change_track(track_attributes)
      expect(current_path).to eq artist_track_list_path(user)
      expect(track_first.reload.title).to eq track_attributes[:title]
      expect(page).to have_selector('.ui-slider-handle')
      expect(page).to have_selector('.bold-text')
    end

    scenario 'delete track', js: true do
      artist_page.open(user)
      expect(page).to have_content('2 BEATS')
      expect(user.tracks.count).to eq 2
      artist_page.click_edit_track(track_second.id)
      expect(current_path).to eq edit_track_path(track_second.id)
      artist_page.delete_track
      expect(current_path).to eq artist_track_list_path(user)
      expect(page).to have_content('ONE BEAT')
      expect(user.tracks.count).to eq 1
    end

    scenario 'cancel edit track', js: true do
      artist_page.open(user)
      expect(page).to have_content('2 BEATS')
      artist_page.click_edit_track(track_second.id)
      expect(current_path).to eq edit_track_path(track_second.id)
      artist_page.cancel_edit_track
      expect(current_path).to eq artist_track_list_path(user)
      expect(page).to have_content('2 BEATS')
    end

    scenario 'share track', js: true do
      artist_page.open(user)
      artist_page.wait_js_execution
      expect(page).to have_content('2 BEATS')
      artist_page.click_share_track(track_second.id)
      artist_page.wait_js_execution
      expect(page).to have_css('.share-modal', visible: false)
      expect(page).to have_css('a.twitter.uk-icon-twitter')
      expect(page).to have_css('a.facebook.uk-icon-facebook')
      expect(page).to have_css('a.tumblr.uk-icon-tumblr')
      expect(page).to have_css('a.googleplus.uk-icon-google-plus')
      expect(page).to have_css('a.email.uk-icon-envelope')
      expect(page).to have_css('a.sms.uk-icon-commenting')
      expect(page).to have_css('#social-share-close')
      artist_page.cancel_share_track
      artist_page.wait_js_execution
      expect(current_path).to eq artist_track_list_path(user)
      expect(page).not_to have_css('.modal-social')
      expect(page).to have_content('2 BEATS')
    end

    scenario "user doesn't have bio" do
      user.update(description: '')
      artist_page.open(user)
      artist_page.wait_js_execution
      expect(page).to have_content('2 BEATS')
      expect(page).to have_no_css('.biography')
    end

    scenario 'user has bio' do
      user.update(description: 'description')
      artist_page.open(user)
      artist_page.wait_js_execution
      expect(page).to have_content('2 BEATS')
      expect(page).to have_css('.biography span', text: user.description)
    end
  end

  context 'visit own artist page' do
    let!(:track) do
      create(:track,
             genres: [genre],
             subgenres: [subgenre_first, subgenre_second],
             user: user,
             title: Faker::Lorem.word,
             description: Faker::Lorem.paragraph,
             audio: File.open("#{Rails.root}/spec/fixtures/audio/Goldhouse.mp3"))
    end

    scenario 'own track partial', js: true do
      artist_page.open(user)
      artist_page.wait_js_execution
      expect(page).to have_css("#rating_list_#{track.id}")
      expect(page).to have_css("a[href='/critiques/#{track.id}']")
      expect(page).to have_css("a[href='/artists/#{user.id}/track_list']", text: user.username.capitalize, class: 'beat__artist-name')
      expect(page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'avatar')
      expect(page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
      expect(page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
      expect(page).to have_css('#share-list')
      expect(page).to have_css("a[href='/tracks/#{track.id}/edit']", text: 'EDIT')
      expect(page).to have_css("a[href='/beats/#{track.id}/social_share']", text: 'SHARE')
      expect(page).to have_no_css("label[for='crit-#{track.id}']", text: 'CRITIQUE')
      expect(page).to have_no_css("label[for='artist-story-#{track.id}']", text: 'STORY')
      expect(page).to have_no_css("label[for='cont-#{track.id}']", text: 'CONTACT')
      expect(page).to have_no_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css('.beat-menu__email', text: user.email)
    end
  end

  context 'visit artist page of another user' do
    let!(:track) do
      create(:track,
             genres: [genre],
             subgenres: [subgenre_first, subgenre_second],
             user: user_second,
             title: Faker::Lorem.word,
             description: Faker::Lorem.paragraph,
             audio: File.open("#{Rails.root}/spec/fixtures/audio/Goldhouse.mp3"))
    end

    scenario 'another user track partial', js: true do
      artist_page.open(user_second)
      artist_page.wait_js_execution
      within('.beat') do
        expect(page).to have_css("#rating_list_#{track.id}")
        expect(page).to have_css("a[href='/critiques/#{track.id}']")
        expect(page).to have_css("a[href='/artists/#{user_second.id}/track_list']", text: user_second.username.capitalize, class: 'beat__artist-name')
        expect(page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'avatar')
        expect(page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
        expect(page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
        expect(page).to have_css('.beat__forms')
        expect(page).to have_css('.beat-menu__tab', count: 4)
        expect(page).to have_css("label[for='crit-#{track.id}']", text: 'CRITIQUE')
        expect(page).to have_css("label[for='artist-story-#{track.id}']", text: 'STORY')
        expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
        expect(page).to have_css("label[for='cont-#{track.id}']", text: 'CONTACT')
        expect(page).to have_no_css('.beat-menu__email', text: user_second.email)
        expect(page).to have_css("a[href='/beats/#{track.id}/social_share']", id: 'share-link')
        expect(page).to have_css("textarea[data-live='#{track.id}']", id: 'comment_body')
        expect(page).to have_css("span[data-count='#{track.id}']")
        expect(page).to have_css('.beat-menu__button')
      end

      artist_page.click_label("label[for='artist-story-#{track.id}']")
      artist_page.wait_js_execution
      expect(page).to have_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css('.beat-menu__email', text: user_second.email)
      expect(page).to have_no_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      artist_page.click_label("label[for='cont-#{track.id}']")
      artist_page.wait_js_execution
      expect(page).to have_css('.beat-menu__email', text: user_second.email)
      expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      artist_page.click_label("label[for='crit-#{track.id}']")
      artist_page.wait_js_execution
      expect(page).to have_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css('.beat-menu__email', text: user_second.email)
    end
  end
end
