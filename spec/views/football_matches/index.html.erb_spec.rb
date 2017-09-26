require 'rails_helper'

describe 'football_matches/index.html.erb' do
  context 'when there is at least one hour before match' do
    it 'displays Place Bet button next to it' do
      sign_in(create(:user))
      barcelona = create(:team, name: 'Barcelona')
      real = create(:team, name: 'Real Madrid')
      allow(view).to receive(:policy) do |record|
        Pundit.policy(User.last, record)
      end
      allow(view).to receive(:bet) { Bet.new }
      allow(view).to receive(:football_matches) {
        [
          create(
            :football_match,
            home_team: barcelona,
            away_team: real,
            match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw')
          )
        ]
      }

      travel_to(DateTime.new(2017, 9, 20, 13, 29).in_time_zone('Warsaw')) do
        render
        page = Capybara.string(rendered)
        row = page.find_table_row('Home Team' => 'Barcelona', 'Away Team' => 'Real Madrid')

        expect(row).to have_link('Place Bet')
      end
    end
  end

  context 'when there is less than one hour until match starts' do
    it 'does not display Place Bet button next to it' do
      sign_in(create(:user))
      barcelona = create(:team, name: 'Barcelona')
      real = create(:team, name: 'Real Madrid')
      allow(view).to receive(:policy) do |record|
        Pundit.policy(User.last, record)
      end
      allow(view).to receive(:bet) { Bet.new }
      allow(view).to receive(:football_matches) {
        [
          create(
            :football_match,
            home_team: barcelona,
            away_team: real,
            match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw')
          )
        ]
      }

      travel_to(DateTime.new(2017, 9, 20, 13, 31).in_time_zone('Warsaw')) do
        render
        page = Capybara.string(rendered)
        row = page.find_table_row('Home Team' => 'Barcelona', 'Away Team' => 'Real Madrid')

        expect(row).not_to have_button('Place Bet')
      end
    end
  end
end
