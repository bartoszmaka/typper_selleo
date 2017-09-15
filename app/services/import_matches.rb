class ImportMatches < Patterns::Service

  def initialize
  end

  def call
    [1, 2].each do |week|
      create_matches_for_given_week(week)
    end
  end

  def create_matches_for_given_week(week)
    attributes_collection = GoalComWrapper.get_round(week)
    round = Round.find_or_create_by(year: 2017, number: week)
    attributes_collection.each do |attribut|
      home_team = Team.find_by!(name: attribut[:home_team_name])
      away_team = Team.find_by!(name: attribut[:away_team_name])
      if attribut[:completed]
        h = {
          home_team_score: attribut[:home_team_score],
          away_team_score: attribut[:away_team_score]
        }
      else
        h = {home_team_score: nil,
        away_team_score: nil}
      end
      a = {
        match_date: attribut[:match_date],
        home_team: home_team,
        away_team: away_team,
        round_id: round.id,
       }
      FootballMatch.find_or_create_by(a.merge! h
      )

    end
  end
end
