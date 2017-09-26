require 'rails_helper'

feature 'Bets management', js: true do
  scenario "visitors can't see Place Bet button" do

    barcelona = create(:team, name: 'Barcelona')
    monaco = create(:team, name: 'Monaco')

    create(:football_match,
           home_team: barcelona,
           away_team: monaco,
           match_date: DateTime.new(2017, 10, 10, 12, 30).in_time_zone('Warsaw'))
    # user_google_oauth2_omniauth_authorize
    # user_google_oauth2_omniauth_callback

    travel_to(DateTime.new(2017, 10, 9, 12, 30)) do
      visit root_path

      expect(page.find_table_row('Match Date' => '2017-10-10 14:30', 'Home Team' => 'Barcelona', 'Away Team' => 'Monaco'))
        .not_to have_link 'Place Bet'
    end
  end

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
      current_user = User.find_by(email: 'bartex@selleo.com' )
      visit root_path

      within(page.find_table_row('Match Date' => '2017-10-10 14:30', 'Home Team' => 'Barcelona', 'Away Team' => 'Monaco')) do
        click_on 'Place Bet'
      end


        within("div.modal.fade.show#myModal-#{first_match.id}") do
          fill_in 'Score Home', with: 0
          fill_in 'Score Away', with: 2
          click_on 'Place Bet'
        end.to change { Bet.count }.by 1

      expect(Bet.all).to include(
        have_attributes(user_id: current_user.id, football_match_id: first_match.id, score_home: 0, score_away: 2)
      )

      expect(page.find_table_row('Match Date' => '2017-10-10 14:30', 'Home Team' => 'Barcelona', 'Away Team' => 'Monaco'))
        .to have_link '0-2'

      within(page.find_table_row('Match Date' => '2017-10-10 14:30', 'Home Team' => 'Barcelona', 'Away Team' => 'Monaco')) do
        click_on '0-2'
      end
      within('div.modal-body') do
        expect(find_field('Score Home').value).to eq '0'
        expect(find_field('Score Away').value).to eq '2'
      end
    end
  end

  def oauth_login_user(email:)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      {
        provider: 'google',
        uid: '12345678910',
        info: {
          email: 'bartex@selleo.com',
          first_name: 'Jesse',
          last_name: 'Spevack'
        },
        credentials: {
          token: 'abcdefg12345',
          refresh_token: '12345abcdefg',
          expires_at: DateTime.now
        }
      }
    )
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # If using Devise
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:default]
    visit user_google_oauth2_omniauth_authorize_path
    OmniAuth.config.mock_auth[:default][:info][:email]
  end
end
