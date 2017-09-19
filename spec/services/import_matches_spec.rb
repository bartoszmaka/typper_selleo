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
          time              | team_home  | team_away     | score away | score home | completed
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
          have_attributes(match_date: DateTime.new(2017, 9, 10, 12, 30), home_team_id: monaco.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id:round_first.id),
          have_attributes(match_date: DateTime.new(2017, 9, 11, 12, 45), home_team_id: real.id, away_team_id: barcelona.id, home_team_score: nil, away_team_score: nil, round_id: round_first.id),
          have_attributes(match_date: DateTime.new(2017, 11, 20, 12, 30), home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
          have_attributes(match_date: DateTime.new(2017, 11, 21, 12, 45), home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id)
        )
      end
    end
  end

  context 'when one round is completed' do
    it 'two Matches have set score' do
      matches_table_page_1 = <<~RATE_PLAN
        WEEK 1 >
        Time              | Team  home  | Team away     | Score away | Score home | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     2      |      1     | true
        2017/09/11 12:45  | Real Madrid |   Barcelona   |     3      |      5     | true
       RATE_PLAN
      matches_table_page_2 = <<~RATE_PLAN
        WEEK 2
        Time              | Team home   | Team away     | Score away | Score home | completed
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
      end.to change { FootballMatch.count}.by(4).and change { Round.count }.by(2)

      expect(Round.all).to include(
        have_attributes(year: 2017, number: 1),
        have_attributes(year: 2017, number: 2)
      )

      round_first = Round.find_by(year: 2017, number: 1)
      round_second = Round.find_by(year: 2017, number: 2)

      expect(FootballMatch.all).to include(
        have_attributes(match_date: DateTime.new(2017, 9, 10, 12, 30), home_team_id: monaco.id, away_team_id: porto.id, home_team_score: 2, away_team_score: 1, round_id:round_first.id),
        have_attributes(match_date: DateTime.new(2017, 9, 11, 12, 45), home_team_id: real.id, away_team_id: barcelona.id, home_team_score: 3, away_team_score: 5, round_id: round_first.id),
        have_attributes(match_date: DateTime.new(2017, 11, 20, 12, 30), home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
        have_attributes(match_date: DateTime.new(2017, 11, 21, 12, 45), home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id)
      )
    end
  end

  context 'when one round was completed' do
    context 'and run second time' do
      it 'updates score' do
        matches_table_page_1 = <<~RATE_PLAN
          WEEK 1 >
          Time              | Team  home  | Team away     | Score away | Score home | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
          2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
         RATE_PLAN
        matches_table_page_2 = <<~RATE_PLAN
          WEEK 2
          Time              | Team home   | Team away     | Score away | Score home | completed
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
          have_attributes(match_date: DateTime.new(2017, 9, 10, 12, 30), home_team_id: monaco.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id:round_first.id),
          have_attributes(match_date: DateTime.new(2017, 9, 11, 12, 45), home_team_id: real.id, away_team_id: barcelona.id, home_team_score: nil, away_team_score: nil, round_id: round_first.id),
          have_attributes(match_date: DateTime.new(2017, 11, 20, 12, 30), home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
          have_attributes(match_date: DateTime.new(2017, 11, 21, 12, 45), home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
        )

        matches_table_page_1_after_call = <<~RATE_PLAN
          WEEK 1 >
          Time              | Team  home  | Team away     | Score away | Score home | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     1      |      5     | true
          2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
         RATE_PLAN
        matches_table_page_2_after_call = <<~RATE_PLAN
          WEEK 2
          Time              | Team home   | Team away     | Score away | Score home | completed
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
          have_attributes(match_date: DateTime.new(2017, 9, 10, 12, 30), home_team_id: monaco.id, away_team_id: porto.id, home_team_score: 1, away_team_score: 5, round_id:round_first.id),
          have_attributes(match_date: DateTime.new(2017, 9, 11, 12, 45), home_team_id: real.id, away_team_id: barcelona.id, home_team_score: nil, away_team_score: nil, round_id: round_first.id),
          have_attributes(match_date: DateTime.new(2017, 11, 20, 12, 30), home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
          have_attributes(match_date: DateTime.new(2017, 11, 21, 12, 45), home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
        )
      end
    end
  end


  context'when are one round and two matches in round' do
    it 'set one round and two' do
      matches_table_page_1 = <<~RATE_PLAN
        WEEK 1 >
        Time              | Team  home  | Team away     | Score away | Score home | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
        2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
       RATE_PLAN

      create(:team, name: 'Monaco')
      create(:team, name: 'Porto')
      create(:team, name: 'Barcelona')
      create(:team, name: 'Real Madrid')

      allow(GoalComWrapper).to receive(:each_round).and_yield(result_from(matches_table_page_1))

      expect do
        ImportMatches.call
      end.to change { FootballMatch.count }.by(2).and change { Round.count }.by(1)
    end
  end

  context 'when are thee round and three matches in round ' do
    it 'set one round and two' do
      matches_table_page_1 = <<~RATE_PLAN
        WEEK 1 >
        Time              | Team  home  | Team away     | Score away | Score home | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
        2017/09/11 12:45  | Real Madrid |   Barcelona   |     0      |      0     | false
        2017/09/11 12:45  | Qarabağ     |   Ac Milan    |     0      |      0     | false
       RATE_PLAN

      matches_table_page_2 = <<~RATE_PLAN
         WEEK 2 >
         Time              | Team  home  | Team away     | Score away | Score home | completed
         ------------------+-------------+---------------+------------+------------------------
         2017/09/20 12:30  | Monaco      |   Qarabağ     |     0      |      0     | false
         2017/09/20 12:45  | Ac Milan    |   Barcelona   |     0      |      0     | false
         2017/09/21 12:45  | Porto       |   Real Madrid |     0      |      0     | false
        RATE_PLAN

      matches_table_page_3 = <<~RATE_PLAN
          WEEK 3
          Time              | Team  home  | Team away     | Score away | Score home | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/10/10 12:30  | Barcelona   |   Porto       |     0      |      0     | false
          2017/10/11 12:45  | Real Madrid |   Qarabağ     |     0      |      0     | false
          2017/10/11 12:45  | Monaco      |   Ac Milan    |     0      |      0     | false
         RATE_PLAN

      create(:team, name: 'Monaco')
      create(:team, name: 'Porto')
      create(:team, name: 'Barcelona')
      create(:team, name: 'Real Madrid')
      create(:team, name: 'Qarabağ')
      create(:team, name: 'Ac Milan')

      allow(GoalComWrapper).to receive(:each_round)
                           .and_yield(result_from(matches_table_page_1))
                           .and_yield(result_from(matches_table_page_2))
                           .and_yield(result_from(matches_table_page_3))

      expect do
        ImportMatches.call
      end.to change { FootballMatch.count }.by(9).and change { Round.count }.by(3)
    end
  end

  def result_from(tabular_data)
    round_number = tabular_data.lines.first.split(' ').second.to_i
    matches = tabular_data.lines[3..-1].map do |line|
      date, home_team_name, away_team_name, home_team_score,
        away_team_score, completed = line.split('|').map(&:strip)
      match_date = DateTime.parse(date)
      OpenStruct.new(
        match_date: match_date,
        home_team_name: home_team_name,
        away_team_name: away_team_name,
        home_team_score: home_team_score.to_i,
        away_team_score: away_team_score.to_i,
        completed: completed == 'true',
      )
    end
     OpenStruct.new(number: round_number, year: matches.first.match_date.year, matches: matches)
  end
end
