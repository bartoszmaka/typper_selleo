require 'rails_helper'
feature 'Bets management' do
  scenario 'Users can place and edit bet' do
    barcelona = create(:team, name: 'Barcelona')
    monaco = create(:team, name: 'Monaco')
    real = create(:team, name: 'Real Madrid')
    fc_porto = create(:team, name: 'Fc Porto')
    first_match = create(:football_match,
                         home_team: barcelona,
                         away_team: monaco,
                         match_date: DateTime.new(2017, 10, 10, 12, 30).in_time_zone('Warsaw'))
    second_match = create(:football_match,
                          home_team: real,
                          away_team: fc_porto,
                          match_date: DateTime.new(2017, 10, 10, 12, 30).in_time_zone('Warsaw'))

    travel_to(DateTime.new(2017, 10, 9, 12, 30)) do
      oauth_login_user(email: 'bartex@selleo.com')
      current_user = User.find_by(email: 'bartex@selleo.com')

      visit root_path

      expect do
        within(page.find_table_row('Match Date' => '2017-10-10 14:30',
                                   'Home Team' => 'Barcelona',
                                   'Away Team' => 'Monaco')) do
          click_on 'Place Bet'
        end
        fill_in 'Barcelona', with: 0
        fill_in 'Monaco', with: 2
        click_on 'Place Bet'
      end.to change { Bet.count }.by(1)

      expect(Bet.all).to include(
        have_attributes(
          user_id: current_user.id,
          football_match_id: first_match.id,
          home_team_score: 0,
          away_team_score: 2
        )
      )

      expect(page.find_table_row('Match Date' => '2017-10-10 14:30',
                                 'Home Team' => 'Barcelona',
                                 'Away Team' => 'Monaco')).to have_link '0 - 2'

      within(page.find_table_row('Match Date' => '2017-10-10 14:30',
                                 'Home Team' => 'Barcelona',
                                 'Away Team' => 'Monaco')) do
        click_on '0 - 2'
      end

      expect(find_field('Barcelona').value).to eq '0'
      expect(find_field('Monaco').value).to eq '2'

      fill_in 'Barcelona', with: 3
      fill_in 'Monaco', with: 1
      click_on 'Place Bet'

      expect(Bet.all).to include(
        have_attributes(
          user_id: current_user.id,
          football_match_id: first_match.id,
          home_team_score: 3,
          away_team_score: 1
        )
      )
    end
  end
end
