require 'rails_helper'

feature 'Home Page' do
  scenario 'lists all matches with Place Bet button' do
    barcelona = create(:team, name: 'Barcelona')
    real      = create(:team, name: 'Real Madrid')
    juventus  = create(:team, name: 'Juventus')
    monaco    = create(:team, name: 'Monaco')

    round = Round.create(number: 1, year: 2017)

    first_match = create(
      :football_match,
      match_date: DateTime.new(2017, 9, 20, 12, 30),
      home_team: barcelona,
      home_team_score: 2,
      away_team_score: 5,
      away_team: real,
      round_id: round.id
    )
    second_match = create(
      :football_match,
      match_date: DateTime.new(2017, 9, 21, 12, 30),
      home_team: juventus,
      home_team_score: nil,
      away_team_score: nil,
      away_team: monaco,
      round_id: round.id
    )

    travel_to DateTime.new(2017, 9, 20, 18, 30)
    visit root_path

    expect(page).to have_table_row(
      'Match Date' => first_match.match_date.localtime.to_formatted_s(:db),
      'Home Team' => 'Barcelona',
      'Away Team' => 'Real Madrid',
      'Score Home' => '2',
      'Score Away' => '5'
    )

    expect(page).to have_table_row(second_match.match_date.localtime.to_formatted_s(:db), 'Juventus', '0', '0', 'Monaco', include('Place Bet'))
    expect(page.all('tbody > tr').first).not_to have_link('Place Bet')
    expect(page.all('tbody > tr').last).to have_link('Place Bet')

    travel_to DateTime.new(2017, 9, 22, 12, 30)
    refresh

    expect(page.all('tbody > tr').last).not_to have_link('Place Bet')
  end
end
