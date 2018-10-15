require 'rails_helper'

feature 'Beats index' do
  let(:charts_page) { ChartsPage.new }
  let(:first_track) { create(:track, title: 'first track') }
  let(:second_track) { create(:track, title: 'second track') }

  before(:each) do
    create(:rating, track: first_track, status: :like)
    create(:rating, track: second_track, status: :dislike)
  end

  scenario 'order tracks', js: true do
    charts_page.open
    expect(page).to have_link('Today')
    expect(page).to have_link('This Week')
    expect(page).to have_link('This Month')
    expect(page).to have_link('All Time')
    expect(page).to have_selector('.beat', count: 2)
    within('#shared_results .beat:nth-child(1)') do
      expect(page).to have_content('First Track')
      expect(page).to have_content('TODAY')
    end
    within('#shared_results .beat:nth-child(2)') do
      expect(page).to have_content('Second Track')
      expect(page).to have_content('TODAY')
    end
    find(:xpath, '//option[contains(text(), "Oldest - Newest")]').select_option
    expect(page).to have_selector('.beat', count: 2)
    charts_page.wait_js_execution
    within('#shared_results .beat:nth-child(1)') do
      expect(page).to have_content('Second Track')
    end
    within('#shared_results .beat:nth-child(2)') do
      expect(page).to have_content('First Track')
    end
  end

  describe 'change period' do
    before(:each) do
      Track::Charted.charted
    end

    scenario 'choosing all time', js: true do
      charts_page.open
      expect(page).to have_selector('.beat', count: 2)
      within('#shared_results .beat:nth-child(1)') do
        expect(page).to have_content('First Track')
        expect(page).to have_content('TODAY')
        expect(page).to have_no_content('ALL')
      end
      click_link('All Time')
      charts_page.wait_js_execution
      expect(page).to have_selector('.beat', count: 2)
      within('#shared_results .beat:nth-child(1)') do
        expect(page).to have_content('First Track')
        expect(page).to have_content('ALL')
        expect(page).to have_no_content('TODAY')
      end
    end
  end
end
