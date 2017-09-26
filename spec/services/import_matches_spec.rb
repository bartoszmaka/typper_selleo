require 'rails_helper'

describe ImportMatches do
  context 'when there are two rounds with two matches each' do
    context 'when there are no completed matches' do
      it 'imports all matches and rounds properly and score set to nil' do
        matches_table_page_1 = <<~RATE_PLAN
          WEEK 1 >
          time              | team_home   | team_away     | score_away | score_home | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
          2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
				RATE_PLAN
        matches_table_page_2 = <<~RATE_PLAN
          WEEK 2
          time              | team_home  | team_away     | score home | score away | completed
          ------------------+-------------+---------------+-------------------------------------
          2017/11/20 12:30  | Monaco      |   Real Madrid |      0     |      0     | false
          2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
				RATE_PLAN

        monaco = create(:team, name: 'Monaco')
        porto = create(:team, name: 'Porto')

        barcelona = create(:team, name: 'Barcelona')
        real = create(:team, name: 'Real Madrid')

        allow(GoalComWrapper).to receive(:each_round)
          .and_yield(result_from(matches_table_page_1))
          .and_yield(result_from(matches_table_page_2))

        expect do
          ImportMatches.call
        end.to change { FootballMatch.count }.by(4).and change { Round.count }.by(2)

        expect(Round.all).to include(
          have_attributes(year: 2017, number: 1),
          have_attributes(year: 2017, number: 2)
        )

        round_first = Round.find_by(year: 2017, number: 1)
        round_second = Round.find_by(year: 2017, number: 2)

        expect(FootballMatch.all).to include(
          have_attributes(
            match_date: DateTime.new(2017, 9, 10, 12, 30),
            home_team_id: monaco.id,
            away_team_id: porto.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_first.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 9, 11, 12, 45),
            home_team_id: real.id,
            away_team_id: barcelona.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_first.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 11, 20, 12, 30),
            home_team_id: monaco.id,
            away_team_id: real.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_second.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 11, 21, 12, 45),
            home_team_id: barcelona.id,
            away_team_id: porto.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_second.id
          )
        )
      end
    end

    context 'when all rounds are completed' do
      it 'change #user_score in round' do
        matches_round_1 = <<~RATE_PLAN
          WEEK 1 >
          Time              | Team  home  | Team away     | Score home | Score away | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     2      |      1     | true
          2017/09/11 12:45  | Real Madrid |   Barcelona   |     3      |      5     | true
        RATE_PLAN
        matches_round_2 = <<~RATE_PLAN
          WEEK 2
          Time              | Team home   | Team away     | Score home | Score away | completed
          ------------------+-------------+---------------+-------------------------------------
          2017/11/20 12:30  | Monaco      |   Real Madrid |      2     |      3     | true
          2017/11/21 12:45  | Barcelona   |   Porto       |      4     |      1     | true
        RATE_PLAN

        monaco = create(:team, name: 'Monaco')
        porto = create(:team, name: 'Porto')
        barcelona = create(:team, name: 'Barcelona')
        real = create(:team, name: 'Real Madrid')

        allow(GoalComWrapper).to receive(:each_round)
          .and_yield(result_from(matches_round_1))
          .and_yield(result_from(matches_round_2))

        ImportMatches.call

        round_first = Round.find_by(year: 2017, number: 1)
        round_second = Round.find_by(year: 2017, number: 2)

        football_match_1 = FootballMatch.find_by(home_team: monaco, away_team: porto)
        football_match_2 = FootballMatch.find_by(home_team: real, away_team: barcelona)
        football_match_3 = FootballMatch.find_by(home_team: monaco, away_team: real)
        football_match_4 = FootballMatch.find_by(home_team: barcelona, away_team: porto)

        user = create(:user)

        bet_1 = create(:bet, football_match: football_match_1, user: user, away_team_score: 1, home_team_score: 2)
        bet_2 = create(:bet, football_match: football_match_2, user: user, away_team_score: 5, home_team_score: 3)
        bet_3 = create(:bet, football_match: football_match_3, user: user, away_team_score: 2, home_team_score: 1)
        bet_4 = create(:bet, football_match: football_match_4, user: user, away_team_score: 3, home_team_score: 2)

        ImportMatches.call

        expect(round_first.user_score(user.id)).to eq 6
        expect(round_second.user_score(user.id)).to eq 1
      end
    end

    context 'when one round is completed' do
      it 'two Matches have set score' do
        matches_table_page_1 = <<~RATE_PLAN
          WEEK 1 >
          Time              | Team  home  | Team away     | Score home | Score away | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     2      |      1     | true
          2017/09/11 12:45  | Real Madrid |   Barcelona   |     3      |      5     | true
      RATE_PLAN
        matches_table_page_2 = <<~RATE_PLAN
          WEEK 2
          Time              | Team home   | Team away     | Score home | Score away | completed
          ------------------+-------------+---------------+-------------------------------------
          2017/11/20 12:30  | Monaco      |   Real Madrid |      0     |      0     | false
          2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
      RATE_PLAN

        monaco = create(:team, name: 'Monaco')
        porto = create(:team, name: 'Porto')
        barcelona = create(:team, name: 'Barcelona')
        real = create(:team, name: 'Real Madrid')

        allow(GoalComWrapper).to receive(:each_round)
          .and_yield(result_from(matches_table_page_1))
          .and_yield(result_from(matches_table_page_2))

        expect do
          ImportMatches.call
        end.to change { FootballMatch.count }.by(4).and change { Round.count }.by(2)

        expect(Round.all).to include(
          have_attributes(year: 2017, number: 1),
          have_attributes(year: 2017, number: 2)
        )

        round_first = Round.find_by(year: 2017, number: 1)
        round_second = Round.find_by(year: 2017, number: 2)

        expect(FootballMatch.all).to include(
          have_attributes(
            match_date: DateTime.new(2017, 9, 10, 12, 30),
            home_team_id: monaco.id,
            away_team_id: porto.id,
            home_team_score: 2,
            away_team_score: 1,
            round_id: round_first.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 9, 11, 12, 45),
            home_team_id: real.id,
            away_team_id: barcelona.id,
            home_team_score: 3,
            away_team_score: 5,
            round_id: round_first.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 11, 20, 12, 30),
            home_team_id: monaco.id,
            away_team_id: real.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_second.id
          ),
          have_attributes(
            match_date: DateTime.new(2017, 11, 21, 12, 45),
            home_team_id: barcelona.id,
            away_team_id: porto.id,
            home_team_score: nil,
            away_team_score: nil,
            round_id: round_second.id
          )
        )
      end

      context 'and run second time' do
        it 'updates score' do
          matches_table_page_1 = <<~RATE_PLAN
            WEEK 1 >
            Time              | Team  home  | Team away     | Score home | Score away | completed
            ------------------+-------------+---------------+------------+------------------------
            2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
            2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
        RATE_PLAN
          matches_table_page_2 = <<~RATE_PLAN
            WEEK 2
            Time              | Team home   | Team away     | Score home | Score away | completed
            ------------------+-------------+---------------+-------------------------------------
            2017/11/20 12:30  | Monaco      |   Real Madrid |      0     |      0     | false
            2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
        RATE_PLAN

          monaco = create(:team, name: 'Monaco')
          porto = create(:team, name: 'Porto')
          barcelona = create(:team, name: 'Barcelona')
          real = create(:team, name: 'Real Madrid')

          allow(GoalComWrapper).to receive(:each_round)
            .and_yield(result_from(matches_table_page_1))
            .and_yield(result_from(matches_table_page_2))

          expect do
            ImportMatches.call
          end.to change { FootballMatch.count }.by(4).and change { Round.count }.by(2)

          expect(Round.all).to include(
            have_attributes(year: 2017, number: 1),
            have_attributes(year: 2017, number: 2)
          )

          round_first = Round.find_by(year: 2017, number: 1)
          round_second = Round.find_by(year: 2017, number: 2)

          expect(FootballMatch.all).to include(
            have_attributes(
              match_date: DateTime.new(2017, 9, 10, 12, 30),
              home_team_id: monaco.id,
              away_team_id: porto.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_first.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 9, 11, 12, 45),
              home_team_id: real.id,
              away_team_id: barcelona.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_first.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 11, 20, 12, 30),
              home_team_id: monaco.id,
              away_team_id: real.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_second.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 11, 21, 12, 45),
              home_team_id: barcelona.id,
              away_team_id: porto.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_second.id
            )
          )

          matches_table_page_1_after_call = <<~RATE_PLAN
            WEEK 1 >
            Time              | Team  home  | Team away     | Score home | Score away | completed
            ------------------+-------------+---------------+------------+------------------------
            2017/09/10 12:30  | Monaco      |   Porto       |     1      |      5     | true
            2017/09/11 12:45  | Real Madrid |   Barcelona   |     2      |      1     | true
        RATE_PLAN
          matches_table_page_2_after_call = <<~RATE_PLAN
            WEEK 2
            Time              | Team home   | Team away     | Score home | Score away | completed
            ------------------+-------------+---------------+-------------------------------------
            2017/11/20 12:30  | Monaco      |   Real Madrid |      0     |      0     | false
            2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
        RATE_PLAN

          allow(GoalComWrapper).to receive(:each_round)
            .and_yield(result_from(matches_table_page_1_after_call))
            .and_yield(result_from(matches_table_page_2_after_call))

          expect do
            ImportMatches.call
          end.to change { FootballMatch.count }.by(0).and(change { Round.count }.by(0))

          round_first = Round.find_by(year: 2017, number: 1)
          round_second = Round.find_by(year: 2017, number: 2)

          expect(FootballMatch.all).to include(
            have_attributes(
              match_date: DateTime.new(2017, 9, 10, 12, 30),
              home_team_id: monaco.id,
              away_team_id: porto.id,
              home_team_score: 1,
              away_team_score: 5,
              round_id: round_first.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 9, 11, 12, 45),
              home_team_id: real.id,
              away_team_id: barcelona.id,
              home_team_score: 2,
              away_team_score: 1,
              round_id: round_first.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 11, 20, 12, 30),
              home_team_id: monaco.id,
              away_team_id: real.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_second.id
            ),
            have_attributes(
              match_date: DateTime.new(2017, 11, 21, 12, 45),
              home_team_id: barcelona.id,
              away_team_id: porto.id,
              home_team_score: nil,
              away_team_score: nil,
              round_id: round_second.id
            )
          )
        end
      end
    end
  end

  context 'when is one round do and three matches' do
    it 'updates bets #point and user #total_points' do
      matches_table_page_1 = <<~RATE_PLAN
        WEEK 1 >
        Time              | Team  home  | Team away     | Score home | Score away | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
        2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
        2017/09/12 12:45  | Liverpool   |   Sevilla     |     0      |      0     | false
      RATE_PLAN

      monaco = create(:team, name: 'Monaco')
      porto = create(:team, name: 'Porto')
      barcelona = create(:team, name: 'Barcelona')
      real = create(:team, name: 'Real Madrid')
      liverpool = create(:team, name: 'Liverpool')
      sevilla = create(:team, name: 'Sevilla')

      allow(GoalComWrapper).to receive(:each_round)
        .and_yield(result_from(matches_table_page_1))

      ImportMatches.call

      football_match_1 = FootballMatch.find_by(home_team: monaco, away_team: porto)
      football_match_2 = FootballMatch.find_by(home_team: real, away_team: barcelona)
      football_match_3 = FootballMatch.find_by(home_team: liverpool, away_team: sevilla)

      user_1 = create(:user, email: 'simon@o2.pl')
      user_2 = create(:user, email: 'bart@o2.pl')

      bet_1 = create(:bet, football_match: football_match_1, user: user_1, away_team_score: 5, home_team_score: 1)
      bet_2 = create(:bet, football_match: football_match_2, user: user_1, away_team_score: 3, home_team_score: 1)
      bet_3 = create(:bet, football_match: football_match_3, user: user_1, away_team_score: 3, home_team_score: 3)

      bet_4 = create(:bet, football_match: football_match_1, user: user_2, away_team_score: 0, home_team_score: 0)
      bet_5 = create(:bet, football_match: football_match_2, user: user_2, away_team_score: 1, home_team_score: 2)

      expect(user_1.total_points).to eq 0
      expect(user_2.total_points).to eq 0

      expect(bet_1).to have_attributes(point: 0)
      expect(bet_2).to have_attributes(point: 0)
      expect(bet_3).to have_attributes(point: 0)
      expect(bet_4).to have_attributes(point: 0)
      expect(bet_5).to have_attributes(point: 0)

      matches_table_page_1_after_call = <<~RATE_PLAN
        WEEK 1 >
        Time              | Team  home  | Team away     | Score home | Score away | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     1      |      5     | true
        2017/09/11 12:45  | Real Madrid |   Barcelona   |     1      |      2     | true
        2017/09/12 12:45  | Liverpool   |   Sevilla     |     0      |      0     | true
      RATE_PLAN

      allow(GoalComWrapper).to receive(:each_round)
        .and_yield(result_from(matches_table_page_1_after_call))

      ImportMatches.call

      expect(bet_1.reload).to have_attributes(point: 3)
      expect(bet_2.reload).to have_attributes(point: 1)
      expect(bet_3.reload).to have_attributes(point: 1)
      expect(bet_4.reload).to have_attributes(point: 0)
      expect(bet_5.reload).to have_attributes(point: 0)

      expect(user_1.total_points).to eq 5
      expect(user_2.total_points).to eq 0
    end
  end

  def result_from(tabular_data)
    round_number = tabular_data.lines.first.split(' ').second.to_i
    matches = tabular_data.lines[3..-1].map do |line|
      date, home_team_name, away_team_name, home_team_score,
        away_team_score, completed = line.split('|').map(&:strip)

      match_date = DateTime.parse(date)
      instance_double(GoalComWrapper::Match,
                      match_date: match_date,
                      home_team_name: home_team_name,
                      away_team_name: away_team_name,
                      home_team_score: home_team_score.to_i,
                      away_team_score: away_team_score.to_i,
                      completed?: completed == 'true')
    end
    instance_double(GoalComWrapper::Round, number: round_number, year: matches.first.match_date.year, matches: matches)
  end
end
