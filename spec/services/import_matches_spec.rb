require 'rails_helper'

describe ImportMatches do

  context 'when there are two rounds with two matches each' do
    context 'when there are no completed matches' do
      it 'imports all matches and rounds properly' do
        matches_table_page_1 = <<~RATE_PLAN
          WEEK 1
          time              | team_home   | team_away     | score_away | score_home | completed
          ------------------+-------------+---------------+------------+------------------------
          2017/09/10 12:30  | Monaco      |   Porto       |     0      |      0     | false
          2017/09/11 12:45  | Real Madryt |   Barcelona   |     0      |      0     | false
        RATE_PLAN
        matches_table_page_2 = <<~RATE_PLAN
          WEEK 2
          time              | team_home  | team_away     | score away | score home | completed
          ------------------+-------------+---------------+-------------------------------------
          2017/11/20 12:30  | Monaco      |   Real Madryt |      0     |      0     | false
          2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
        RATE_PLAN

        monaco = create(:team, name: 'Monaco')
        porto = create(:team, name: 'Porto')
        barcelona = create(:team, name: 'Barcelona')
        real = create(:team, name: 'Real Madryt')

        allow(GoalComWrapper).to receive(:get_round).with(1) { result_from(matches_table_page_1) }
        allow(GoalComWrapper).to receive(:get_round).with(2) { result_from(matches_table_page_2) }

        expect do
          ImportMatches.call
        end.to change{ FootballMatches.count}.by(4).and change{ Round.count }.by(2)

        expect(Round.all).to include(
          have_attributes(year: '2017', number: 1),
          have_attributes(year: '2017', number: 2),
        )

        round_first = Round.find_by(year: '2017', number: 1)
        round_second = Round.find_by(year: '2017', number: 2)

        expect(FootballMatch.all).to include(
          have_attributes(match_data: "2017/09/10 12:30", home_team_id: monaco.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id:round_first.id ),
          have_attributes(match_data: "2017/09/11 12:45", home_team_id: real.id, away_team_id: barcelona.id, home_team_score: nil, away_team_score: nil, round_id: round_first.id),
          have_attributes(match_data: "2017/11/20 12:30", home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
          have_attributes(match_data: "2017/11/21 12:45", home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
        )
      end
    end
  end
  context 'when one round is completed' do
    it 'two Matches will have set score' do
      matches_table_page_1 = <<~RATE_PLAN
        WEEK 1
        Time              | Team  home  | Team away     | Score away | Score home | completed
        ------------------+-------------+---------------+------------+------------------------
        2017/09/10 12:30  | Monaco      |   Porto       |     2      |      1     | true
        2017/09/11 12:45  | Real Madryt |   Barcelona   |     3      |      5     | true
       RATE_PLAN
      matches_table_page_2 = <<~RATE_PLAN
      WEEK 2
        Time              | Team home   | Team away     | Score away | Score home | completed
        ------------------+-------------+---------------+-------------------------------------
        2017/11/20 12:30  | Monaco      |   Real Madryt |      0     |      0     | false
        2017/11/21 12:45  | Barcelona   |   Porto       |      0     |      0     | false
      RATE_PLAN

       monaco = create(:team, name: 'Monaco')
       porto = create(:team, name: 'Porto')
       barcelona = create(:team, name: 'Barcelona')
       real = create(:team, name: 'Real Madryt')

       allow(GoalComWrapper).to receive(:get_round).with(1) { result_from(matches_table_page_1) }
       allow(GoalComWrapper).to receive(:get_round).with(2) { result_from(matches_table_page_2) }

      expect do
        ImportMatches.call
      end.to change{ FootballMatches.count}.by(4).and change{ Round.count }.by(2)

       # match_array
      expect(Round.all).to include(
        have_attributes(year: '2017', number: 1),
        have_attributes(year: '2017', number: 2),
      )

      round_first = Round.find_by(year: '2017', number: 1)
      round_second = Round.find_by(year: '2017', number: 2)

      expect(FootballMatch.all).to include(
        have_attributes(match_data: "2017/09/10 12:30", home_team_id: monaco.id, away_team_id: porto.id, home_team_score: 2, away_team_score: 1, round_id:round_first.id ),
        have_attributes(match_data: "2017/09/11 12:45", home_team_id: real.id, away_team_id: barcelona.id, home_team_score: 3, away_team_score: 5, round_id: round_first.id),
        have_attributes(match_data: "2017/11/20 12:30", home_team_id: monaco.id, away_team_id: real.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
        have_attributes(match_data: "2017/11/21 12:45", home_team_id: barcelona.id, away_team_id: porto.id, home_team_score: nil, away_team_score: nil, round_id: round_second.id),
      )
     end
   end
 end

 # allow(GoalComWrapper).to receive(:get_round).with(1) { result_from(matches_table_page_1) }
 # allow(GoalComWrapper).to receive(:get_round).with(2) { result_from(matches_table_page_2) }

  def result_from(tabular_data)
    tabular_data.lines[3..-1].map do |line|
      match_attribute_values = line.split('|').map(&:strip)
      {
        time: DateTime.parse(match_attribute_values[0]),
        home_team_name: match_attribute_values[1],
        away_team_name: match_attribute_values[2],
        home_team_score: match_attribute_values[3].to_i,
        away_team_score: match_attribute_values[4].to_i,
        completed: match_attribute_values[5] == 'true',
        round_id: tabular_data.lines.first.split(' ').last.to_i
      }
    end
  end



      # [
      #   {
      #     match_data: '2017/09/10 12:30',
      #     home_team: 'Monaco',
      #     away_team: 'Porto',
      #     home_team_score: 0,
      #     away_team_score: 0
      #   },
      #   {
      #     match_data: '2017/09/11 12:45',
      #     home_team: 'Real Madryt',
      #     away_team: 'Barcelona',
      #     home_team_score: 0,
      #     away_team_score: 0
      #   },
      #   {
      #     match_data: '2017/11/20 12:30',
      #     home_team: 'Monaco',
      #     away_team: 'Real Madryt',
      #     home_team_score: 0,
      #     away_team_score: 0
      #   },
      #   {
      #     match_data: '2017/11/21 12:45',
      #     home_team: 'Barcelona',
      #     away_team: 'Porto',
      #     home_team_score: 0,
      #     away_team_score: 0
      #   }
      # ]
    # end
#   it 'creates 96 matches in total' do
#     expect { call_match_loader }.to change { FootballMatch.count }.by 96
#   end
#
#   it 'is idempotent service' do
#     call_match_loader
#     expect(FootballMatch.count).to eq(96)
#     call_match_loader
#     expect(FootballMatch.count).to eq(96)
#   end
#
#   it 'has exactly 16 matches per round' do
#     call_match_loader
#
#     expect(Round.sort_by(&:matches).first.count).to eq 16
#     expect(Round.sort_by(&:matches).last.count).to eq 16
#   end
# end
#
# def call_match_loader
#   team_casset = 'team_web_collection'
#   VCR.use_cassette(team_casset) do
#     ImportMatches.call.result
#   end
# end
#
# #   keys = tabular_data.lines[0].chomp
# #   match_first  = tabular_data.lines[2].chomp
# #   match_second = tabular_data.lines[3].chomp
# #
# #
# # [{},{}]
# # [
# #   {match: {data: asas, te}, round: {atributes} }
# #   {match: {attribute}, round: {atributes} }
# #   {match_1_attributes},
# #   {match_2_attributes},
# #   {match_3_attributes},
# #   {match_4_attributes}
# # ]
