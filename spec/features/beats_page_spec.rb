require 'rails_helper'

feature 'Beats index' do
  let(:beats_page) { BeatsPage.new }

  let!(:user) { create(:user) }
  let!(:track) do
    create(:track,
           user: user,
           title: Faker::Lorem.word,
           description: Faker::Lorem.paragraph,
           audio: File.open("#{Rails.root}/spec/fixtures/audio/Goldhouse.mp3"))
  end

  describe 'count of display tracks', js: true do
    before do
      create(:track, streamable: false)
      create(:track, streamable: false, user: user)
    end

    context 'unregistered user' do
      before { allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(false) }

      scenario 'only public tracks', js: true do
        beats_page.open
        beats_page.wait_js_execution
        expect(beats_page).to have_selector('.beat', count: 1)
      end
    end

    context 'registered user' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      scenario "only public tracks or user's tracks", js: true do
        beats_page.open
        beats_page.wait_js_execution
        expect(beats_page).to have_selector('.beat', count: 2)
      end
    end
  end

  describe 'unregistered User', js: true do
    before { allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(false) }

    scenario 'cannot add like rating' do
      beats_page.open
      beats_page.wait_js_execution
      expect(page.current_path).to eq(beats_path)
      within("#rating_list_#{track.id}") do
        original = page.find("#like_#{track.id}").text.to_i
        result = page.find("#like_#{track.id}").text.to_i
        expect(result).to eq(original)
        expect(beats_page).to have_css('svg.like')
        expect(beats_page).to have_css('svg.indifferent')
        expect(beats_page).to have_css('svg.dislike')
      end
    end

    scenario 'cannot add indifferent rating' do
      beats_page.open
      beats_page.wait_js_execution
      expect(page.current_path).to eq(beats_path)
      within("#rating_list_#{track.id}") do
        original = page.find("#indifferent_#{track.id}").text.to_i
        result = page.find("#indifferent_#{track.id}").text.to_i
        expect(result).to eq(original)
        expect(beats_page).to have_css('svg.like')
        expect(beats_page).to have_css('svg.indifferent')
        expect(beats_page).to have_css('svg.dislike')
      end
    end

    scenario 'cannot add dislike rating' do
      beats_page.open
      beats_page.wait_js_execution
      expect(page.current_path).to eq(beats_path)
      within("#rating_list_#{track.id}") do
        original = page.find("#dislike_#{track.id}").text.to_i
        result = page.find("#dislike_#{track.id}").text.to_i
        expect(result).to eq(original)
        expect(beats_page).to have_css('svg.like')
        expect(beats_page).to have_css('svg.indifferent')
        expect(beats_page).to have_css('svg.dislike')
      end
    end
  end

  describe 'beats' do
    scenario 'partial track' do
      beats_page.open
      beats_page.wait_js_execution
      expect(page.current_path).to eq(beats_path)
      within('.beat') do
        expect(page).to have_css("#rating_list_#{track.id}")
        expect(page).to have_css("a[href='/critiques/#{track.id}']")
        expect(page).to have_css("a[href='/artists/#{user.id}/track_list']", text: user.username.capitalize, class: 'beat__artist-name')
        expect(page).to have_css("img[src='#{track.image_url(:thumb)}']", class: 'avatar')
        expect(page).to have_css("#waveform-proc[data-url='#{track.audio.url}']")
        expect(page).to have_css("#waveform-proc[data-waveform='#{track.waveform}']")
        expect(page).to have_css('.beat__forms')
        expect(page).to have_css('.beat-menu__tab', count: 4)
        expect(page).to have_css("label[for='crit-#{track.id}']", text: 'CRITIQUE')
        expect(page).to have_css("label[for='artist-story-#{track.id}']", text: 'STORY')
        expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
        expect(page).to have_css("label[for='cont-#{track.id}']", text: 'CONTACT')
        expect(page).to have_no_css('.beat-menu__email', text: user.email)
        expect(page).to have_css("a[href='/beats/#{track.id}/social_share']", id: 'share-link')
        expect(page).to have_css("textarea[data-live='#{track.id}']", id: 'comment_body')
        expect(page).to have_css("span[data-count='#{track.id}']")
        expect(page).to have_css('.beat-menu__button')
      end
      beats_page.click_label("label[for='artist-story-#{track.id}']")
      beats_page.wait_js_execution
      expect(page).to have_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css('.beat-menu__email', text: user.email)
      expect(page).to have_no_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      beats_page.click_label("label[for='cont-#{track.id}']")
      beats_page.wait_js_execution
      expect(page).to have_css('.beat-menu__email', text: user.email)
      expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      beats_page.click_label("label[for='crit-#{track.id}']")
      beats_page.wait_js_execution
      expect(page).to have_css("textarea[data-live='#{track.id}']", id: 'comment_body')
      expect(page).to have_no_css('.beat-menu__content-story', text: track.description)
      expect(page).to have_no_css('.beat-menu__email', text: user.email)
    end
  end
end
