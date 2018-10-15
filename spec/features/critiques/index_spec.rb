require 'rails_helper'

feature 'Critiques index' do
  let(:critiques_page) { CritiquesPage.new }
  let!(:user_1) { create(:mock_user) }
  let!(:user_2) { create(:mock_user) }
  let!(:track_1) { create(:track, user: user_1) }
  let!(:track_2) { create(:track, user: user_2) }
  let!(:critique_1) { create(:critique, track: track_1) }
  let!(:critique_2) { create(:critique, track: track_2) }
  let!(:comment_1) { create(:comment, user: user_2, critique: critique_1, commentable: track_1) }
  let!(:comment_2) { create(:comment, user: user_1, critique: critique_2, commentable: track_2) }

  describe 'registered User' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
    end

    scenario 'visit page', js: true do
      critiques_page.open
      critiques_page.wait_js_execution
      expect(page.current_path).to eq(critiques_path)
      expect(page).to have_css('.top-panel__title', text: 'CRITIQUES')
      expect(page).to have_css('a', text: 'CRITIQUES GIVEN')
      expect(page).to have_css('a', text: 'CRITIQUES RECEIVED')
      # show critiques received
      critiques_page.show_received_critiques
      critiques_page.wait_js_execution
      expect(page).to have_css('#critiques_count', text: '1 RECEIVED')
      expect(page).to have_css('select#critiques_sort', count: 1)
      expect(page).to have_css('li.critique-item', count: 1, visible: false)
      within '.columns.is-gapless' do
        expect(page).to have_css('.critique-thumb img')
        expect(page).to have_content(user_1.name)
        expect(page).to have_css('.critique-comment', text: comment_1.body)
        expect(page).to have_css('.critique-right .critique-of', text: 'Critique of')
        expect(page).to have_css('.critique-right .song-name', text: track_1.title)
        expect(page).to have_css(".critique-right a[href='/critiques/#{track_1.id}']", text: 'SEE FULL BEAT THREAD')
      end
      # show critiques given
      critiques_page.show_given_critiques
      critiques_page.wait_js_execution
      expect(page).to have_css('#critiques_count', text: '1 GIVEN')
      expect(page).to have_css('select#critiques_sort', count: 1)
      expect(page).to have_css('li.critique-item', count: 1, visible: false)
      within '.columns.is-gapless' do
        expect(page).to have_css('.critique-thumb img')
        expect(page).to have_content(user_2.name)
        expect(page).to have_css('.critique-comment', text: comment_2.body)
        expect(page).to have_css('.critique-right .critique-of', text: 'Critique of')
        expect(page).to have_css('.critique-right .song-name', text: track_2.title)
        expect(page).to have_css(".critique-right a[href='/critiques/#{track_2.id}']", text: 'SEE FULL BEAT THREAD')
      end
      # show critiques received
      critiques_page.show_received_critiques
      critiques_page.wait_js_execution
      expect(page).to have_css('#critiques_count', text: '1 RECEIVED')
      expect(page).to have_css('li.critique-item', count: 1, visible: false)
    end
  end

  describe 'unregistered User' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(false)
    end

    scenario 'visit page', js: true do
      critiques_page.open
      critiques_page.wait_js_execution
      expect(page.current_path).to eq(root_path)
    end
  end
end
