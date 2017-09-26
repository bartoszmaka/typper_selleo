require 'rails_helper'

feature 'Scoreboard' do
  context 'when are 6 round' do
    context 'when users have different number of points' do
      scenario 'user can see list of users ordered by sum of their points' do
        oauth_login_user(email: 'example.first@selleo.com')
        user_1 = User.find_by(email: 'example.first@selleo.com')
        user_2 = create(:user, email: 'example.second@selleo.com')
        round_1 = create(:round, number: 1)
        round_2 = create(:round, number: 2)
        4.times { |number| create(:round, number: number + 3) }

        football_match1 = create(:football_match, match_date: DateTime.new(2017, 10, 10, 12, 30), round_id: round_1.id)
        football_match2 = create(:football_match, match_date: DateTime.new(2017, 10, 11, 12, 30), round_id: round_2.id)

        bet_user_1_match_1 = create(:bet,
                                    user_id: user_1.id,
                                    football_match_id: football_match1.id,
                                    away_team_score: 2,
                                    home_team_score: 1)
        bet_user_2_match_1 = create(:bet,
                                    user_id: user_2.id,
                                    football_match_id: football_match1.id,
                                    away_team_score: 3,
                                    home_team_score: 1)

        bet_user_1_match_2 = create(:bet,
                                    user_id: user_1.id,
                                    football_match_id: football_match2.id,
                                    away_team_score: 1,
                                    home_team_score: 3)
        bet_user_2_match_2 = create(:bet,
                                    user_id: user_2.id,
                                    football_match_id: football_match2.id,
                                    away_team_score: 3,
                                    home_team_score: 2)

        bet_user_1_match_1.update_attributes(point: 3)
        bet_user_2_match_1.update_attributes(point: 1)

        visit scoreboards_path

        expect(page).to have_table_row(
          'Name' => 'Example. First',
          'Round1' => '3',
          'Round2' => '0',
          'Round3' => '0',
          'Round4' => '0',
          'Round5' => '0',
          'Round6' => '0',
          'Total' => '3'
        )

        expect(page).to have_table_row(
          'Name' => 'Example. Second',
          'Round1' => '1',
          'Round2' => '0',
          'Round3' => '0',
          'Round4' => '0',
          'Round5' => '0',
          'Round6' => '0',
          'Total' => '1'
        )

        expect(page.all('tbody > tr')[0].text).to start_with 'Example. First'
        expect(page.all('tbody > tr')[1].text).to start_with 'Example. Second'

        bet_user_1_match_2.update_attributes(point: 0)
        bet_user_2_match_2.update_attributes(point: 3)

        visit scoreboards_path

        expect(page).to have_table_row(
          'Name' => 'Example. First',
          'Round1' => '3',
          'Round2' => '0',
          'Round3' => '0',
          'Round4' => '0',
          'Round5' => '0',
          'Round6' => '0',
          'Total' => '3'
        )

        expect(page).to have_table_row(
          'Name' => 'Example. Second',
          'Round1' => '1',
          'Round2' => '3',
          'Round3' => '0',
          'Round4' => '0',
          'Round5' => '0',
          'Round6' => '0',
          'Total' => '4'
        )

        expect(page.all('tbody > tr')[0].text).to start_with 'Example. Second'
        expect(page.all('tbody > tr')[1].text).to start_with 'Example. First'
      end
    end
  end
end
