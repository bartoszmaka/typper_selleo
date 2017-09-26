require 'rails_helper'

feature 'maangment_page' do
  context 'when user is log in' do
    scenario "can't see button to updates match and point bets and can see navigation to scoreboard" do
      sign_in create(:user)

      visit football_matches_path

      expect(page).to have_link('Scoreboard')
      expect(page).not_to have_link('Update score')
    end
  end

  context 'when admin is login' do
    scenario 'can see button to updates match and point bets' do
      sign_in create(:user, role: 'admin')

      visit football_matches_path

      expect(page).to have_link('Scoreboard')
      expect(page).to have_link('Update score')
    end
  end
end
