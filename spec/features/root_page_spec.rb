require 'rails_helper'

feature 'Home Page' do
  context 'there are completed and pending matches' do
    scenario 'user visits root page' do
      barcelona = create(:team, name: 'Barcelona')
      real      = create(:team, name: 'Real Madrid')
      juventus  = create(:team, name: 'Juventus')
      monaco    = create(:team, name: 'Monaco')
      round = create(:round)
      create(:football_match,
             match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'),
             home_team: barcelona,
             home_team_score: 2,
             away_team_score: 5,
             away_team: real,
             round_id: round.id)
      create(:football_match,
             match_date: DateTime.new(2017, 9, 21, 12, 30).in_time_zone('Warsaw'),
             home_team: juventus,
             away_team: monaco,
             round_id: round.id)

      sign_in(create(:user))

      travel_to DateTime.new(2017, 9, 20, 10, 30).in_time_zone('Warsaw') do
        visit root_path

        expect(page).to have_table_row('2017-09-21 14:30',
                                       'Juventus',
                                       '0',
                                       '0',
                                       'Monaco',
                                       have_link('a', text: 'Place Bet'))
      end
    end
  end
end
