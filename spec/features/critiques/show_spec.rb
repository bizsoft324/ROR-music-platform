require 'rails_helper'

feature 'Critiques' do
  let(:critique_page) { CritiquePage.new }
  let!(:user) { create(:mock_user) }
  let!(:user_2) { create(:mock_user) }
  let!(:user_3) { create(:mock_user) }
  let!(:track) do
    create(:track,
           user: user,
           title: Faker::Lorem.word,
           description: Faker::Lorem.paragraph,
           audio: File.open("#{Rails.root}/spec/fixtures/audio/Goldhouse.mp3"))
  end
  let!(:critique) { create(:critique, track: track) }
  let!(:comment_1) { create(:comment, user: user_2, critique: critique, commentable: track, body: 'This is oldest comment') }
  let!(:comment_2) { create(:comment, user: user_3, critique: critique, commentable: track, body: 'This is newest comment') }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) }

  describe 'registered User' do
    before { allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true) }

    scenario 'show', js: true do
      critique_page.open
      critique_page.wait_js_execution
      expect(page).to have_no_css('.critique__modal')
      critique_page.open_modal(track.id)
      critique_page.wait_js_execution
      expect(page).to have_css('.critique__modal')
      expect(page).to have_css("img[src='#{track.image_url(:original)}']", class: 'background-track-image')
      within('.artist__header') do
        expect(page).to have_css('.artist__thumb')
        expect(page).to have_css('.verified-icon')
        expect(page).to have_css("a[href='/artists/#{user.id}/track_list']", text: user.username.capitalize)
        expect(page).to have_css('span', text: track.title.capitalize)
      end
      within('.rectangle-232') do
        expect(page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'artist__avatar')
        expect(page).to have_css("ul#rating_list_#{track.id}")
        expect(page).to have_css("a[href='/beats/#{track.id}/social_share']")
        expect(page).to have_css('img[alt="Share"]')
        expect(page).to have_css('canvas')
        expect(page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
        expect(page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
      end
      expect(page).to have_css('#critiques_counter')
      expect(page).to have_css('select#critiques_order', visible: false)
      expect(page).to have_css('ul#critique_comment_list', visible: false)
      within('ul#critique_comment_list', visible: false) do
        expect(page).to have_css('li.comment.media', count: 2)
        expect(page).to have_css('.media-left h5', text: user_2.username.capitalize, count: 1)
        expect(page).to have_css('.media-left h5', text: user_3.username.capitalize, count: 1)
        expect(page).to have_css('.media-content p', text: comment_1.body, count: 1)
        expect(page).to have_css('.media-content p', text: comment_2.body, count: 1)
      end
      expect(page).to have_css("form#form_show_#{track.id}")
      expect(page).to have_css("textarea[data-live='#{track.id}']")
      expect(page).to have_css('button .send_comment--submit')
      critique_page.close_modal
      critique_page.wait_js_execution
      expect(page).to have_no_css('.critique__modal')
    end

    scenario 'show critique by clicking on beat avatar', js: true do
      critique_page.open
      critique_page.wait_js_execution
      expect(page).to have_no_css('.critique__modal')
      critique_page.click_beat_avatar
      critique_page.wait_js_execution
      expect(page).to have_css('.critique__modal')
    end

    scenario 'critiques order sorting', js: true do
      critique_page.open
      critique_page.wait_js_execution
      critique_page.open_modal(track.id)
      critique_page.wait_js_execution
      expect(page).to have_selector('ul#critique_comment_list li:nth-child(1)', text: 'This is newest comment')
      expect(page).to have_selector('ul#critique_comment_list li:nth-child(2)', text: 'This is oldest comment')
      critique_page.click_oldest_newest_order
      critique_page.wait_js_execution
      expect(page).to have_selector('ul#critique_comment_list li:nth-child(2)', text: 'This is newest comment')
      expect(page).to have_selector('ul#critique_comment_list li:nth-child(1)', text: 'This is oldest comment')
    end

    scenario 'critique html template', js: true do
      critique_page.open_html_critique(track.id)
      critique_page.wait_js_execution
      expect(page).to have_css("img[src='#{track.image_url(:original)}']", class: 'background-track-image')
      within('.artist__header') do
        expect(page).to have_css('.artist__thumb')
        expect(page).to have_css('.verified-icon')
        expect(page).to have_css("a[href='/artists/#{user.id}/track_list']", text: user.username.capitalize)
        expect(page).to have_css('span', text: track.title.capitalize)
      end
      within('.rectangle-232') do
        expect(page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'artist__avatar')
        expect(page).to have_css("ul#rating_list_#{track.id}")
        expect(page).to have_css("a[href='/beats/#{track.id}/social_share']")
        expect(page).to have_css('img[alt="Share"]')
        expect(page).to have_css('canvas')
        expect(page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
        expect(page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
      end
      expect(page).to have_css('#critiques_counter')
      expect(page).to have_css('select#critiques_order', visible: false)
      expect(page).to have_css('ul#critique_comment_list', visible: false)
      within('ul#critique_comment_list', visible: false) do
        expect(page).to have_css('li.comment.media', count: 2)
        expect(page).to have_css('.media-left h5', text: user_2.username.capitalize, count: 1)
        expect(page).to have_css('.media-left h5', text: user_3.username.capitalize, count: 1)
        expect(page).to have_css('.media-content p', text: comment_1.body, count: 1)
        expect(page).to have_css('.media-content p', text: comment_2.body, count: 1)
      end
      expect(page).to have_css("form#form_show_#{track.id}")
      expect(page).to have_css("textarea[data-live='#{track.id}']")
      expect(page).to have_css('button .send_comment--submit')
    end
  end

  describe 'unregistered User' do
    before { allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(false) }

    scenario 'show', js: true do
      critique_page.open
      critique_page.wait_js_execution
      expect(page).to have_no_css('.critique__modal')
      critique_page.open_modal(track.id)
      critique_page.wait_js_execution
      expect(page).to have_css('.critique__modal')
      expect(page).to have_css("img[src='#{track.image_url(:original)}']", class: 'background-track-image')
      within('.artist__header') do
        expect(critique_page).to have_css('.artist__thumb')
        expect(critique_page).to have_css('.verified-icon')
        expect(critique_page).to have_css("a[href='/artists/#{user.id}/track_list']", text: user.username.capitalize)
        expect(critique_page).to have_css('span', text: track.title.capitalize)
      end
      within('.rectangle-232') do
        expect(critique_page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'artist__avatar')
        expect(critique_page).to have_css("ul#rating_list_#{track.id}")
        expect(critique_page).to have_css("a[href='/beats/#{track.id}/social_share']")
        expect(critique_page).to have_css('img[alt="Share"]')
        expect(critique_page).to have_css('canvas')
        expect(critique_page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
        expect(critique_page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
      end
      expect(critique_page).to have_css('#critiques_counter')
      expect(critique_page).to have_css('select#critiques_order', visible: false)
      expect(critique_page).to have_css('ul#critique_comment_list', visible: false)
      within('ul#critique_comment_list', visible: false) do
        expect(page).to have_css('li.comment.media', count: 2)
        expect(page).to have_css('.media-left h5', text: user_2.username.capitalize, count: 1)
        expect(page).to have_css('.media-left h5', text: user_3.username.capitalize, count: 1)
        expect(page).to have_css('.media-content p', text: comment_1.body, count: 1)
        expect(page).to have_css('.media-content p', text: comment_2.body, count: 1)
      end
      expect(critique_page).to have_no_css("form#form_show_#{track.id}")
      critique_page.close_modal
      critique_page.wait_js_execution
      expect(page).to have_no_css('.critique__modal')
    end
  end
end
