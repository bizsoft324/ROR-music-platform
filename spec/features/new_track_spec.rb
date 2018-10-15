require 'rails_helper'

feature 'Track Uploading' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre, name: 'Hip-Hop') }
  let!(:subgenre_first) { create(:subgenre, name: 'West Coast Hip-Hop', genre: genre) }
  let!(:subgenre_second) { create(:subgenre, name: 'Crunk', genre: genre) }
  let(:new_track_page) { NewTrackPage.new }
  let(:other_track) { create(:track) }
  let(:critique) { create(:critique, track: other_track) }
  let!(:comment) { create(:comment, user: user, critique: critique, commentable: other_track) }

  describe 'Registered user' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
    end

    scenario 'Track uploading buttons exist', js: true do
      new_track_page.open
      expect(page).to have_content('UPLOAD A BEAT')
      expect(page).to have_selector('[data-upload-content]')
      expect(page).to have_selector('.beat-uploading__choose-file')
      expect(page.has_content?('CHOOSE FILE TO UPLOAD') || page.has_content?('UPLOAD')).to be true
      expect(page).to have_selector('.beat-uploading__file')
      expect(page).to have_content('THEN CHOOSE BEATS TO IMPORT')
      # expect(page).to have_selector('.beat-uploading__choose-file.beat-uploading__choose-file--scloud')
      expect(page).to have_field('track[audio]', visible: false, match: :first)
      # expect(find('.beat-uploading__choose-file.beat-uploading__choose-file--scloud img')['src']).to have_content('soundcloud-logo')
    end

    scenario 'Uploading modal window exists', js: true do
      new_track_page.open
      new_track_page.wait_js_execution
      new_track_page.attach_audio
      new_track_page.wait_js_execution

      within '.beat-uploading-content' do
        expect(page).to have_selector('.uploading-progress')
        expect(page).to have_selector('.beat-uploading__left')
        expect(page).to have_selector('.beat-uploading-right')
        expect(page).to have_selector("img[id='image_upload_preview']")
        expect(page).to have_selector("label[for='inputFile']")
        expect(page).to have_content('ADD IMAGE')
        expect(page).to have_selector("input[placeholder='Beat Title']")
        expect(page).to have_selector("textarea[name='track[description]']")
        expect(page).to have_selector("textarea[placeholder='Add information about your beat']")
        expect(page).to have_selector("img[alt='Eye one']")
        expect(page).to have_selector("img[alt='Eye two']")
        expect(page).to have_selector('.ui-slider-handle')
        expect(page).to have_selector('.bold-text')
        expect(page).to have_content('PRIVATE')
        expect(page).to have_content('PUBLIC')
        expect(page).to have_selector('select', count: 2)
        expect(page).to have_selector("input[value='finish']")
        expect(page).to have_content('CANCEL')
      end
    end

    scenario 'Uploading modal window closes', js: true do
      new_track_page.open
      new_track_page.wait_js_execution
      new_track_page.attach_audio
      new_track_page.wait_js_execution

      find("a[id='close-form']").trigger :click
      expect(page).not_to have_selector('.beat-uploading-content')
    end

    scenario 'Frontend validations and cancel to create track', js: true do
      new_track_page.open
      new_track_page.wait_js_execution
      new_track_page.attach_audio
      new_track_page.wait_js_execution
      expect(page).to have_field('track[title]', text: '', placeholder: 'Beat Title', visible: false)
      expect(page).to have_field('track[description]', text: '', placeholder: 'Add information about your beat', visible: false)
      expect(page).to have_field('track[image]', visible: false)
      expect(page).not_to have_content('Beat title required')
      expect(page).not_to have_content('Image required')
      expect(page).not_to have_content('Track description required')
      expect(page).not_to have_content('Subgenre must be selected')
      click_on 'finish'
      expect(page).to have_content('Beat title required')
      expect(page).to have_content('Track description required')
      expect(page).to have_content('Subgenre must be selected')
      fill_in 'track[title]', with: 'New Beat'
      expect(page).not_to have_content('Beat title required')
      fill_in 'track[description]', with: 'description'
      expect(page).not_to have_content('Track description required')
      select 'West Coast Hip-Hop', from: 'track[subgenre_ids][]', match: :first
      expect(page).not_to have_content('Subgenre must be selected')

      find('#close-form').trigger :click
      new_track_page.wait_js_execution
      expect(page).not_to have_selector('#beat_uploading_content')
      expect(page).to have_selector('[data-upload-content]')
      new_track_page.attach_audio
      new_track_page.wait_js_execution
      expect(page).to have_selector('#beat_uploading_content')
      expect(page).to have_field('track[title]', text: '', placeholder: 'Beat Title', visible: false)
      expect(page).to have_field('track[description]', text: '', placeholder: 'Add information about your beat', visible: false)
      expect(page).to have_field('track[image]', visible: false)
    end

    scenario 'Dropdowns display genres and subgenres', js: true do
      new_track_page.open
      new_track_page.wait_js_execution
      new_track_page.attach_audio
      new_track_page.wait_js_execution

      within '.beat-uploading-content' do
        select 'Hip-Hop', from: 'track[genre_ids][]'
        expect(page).to have_selector('select', count: 2)
        new_track_page.append_subgenres_with_js
        expect(page).to have_select('track[subgenre_ids][]', with_options: ['West Coast Hip-Hop', 'Crunk'], count: 1)
      end
    end
  end

  describe 'Unregistered user' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(false)
    end

    scenario 'visit new track page', js: true do
      new_track_page.open
      new_track_page.wait_js_execution
      expect(page.current_path).to eq(root_path)
    end
  end
end
