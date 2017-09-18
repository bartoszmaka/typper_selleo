class ImportMatches < Patterns::Service
  def call
    all_weeks.each do |week|
      create_matches_for_given_week(week)
    end
  end

 def create_matches_for_given_week(week)
    attribute_hashes_collection = GoalComWrapper.get_round(week)
    attribute_hashes_collection.map do |attributes_hash|
      home_team = Team.find_by!(name: attributes_hash[:home_team_name])
      away_team = Team.find_by!(name: attributes_hash[:away_team_name])
      round_year = attributes_hash[:round_year]
      round_number = attributes_hash[:round_number]
      round = Round.find_or_create_by(year: round_year, number: round_number)
      match_attributes = {
        match_date: attributes_hash[:match_date],
        home_team: home_team,
        away_team: away_team,
        round_id: round.id
      }
      football_match = FootballMatch.find_or_create_by(match_attributes)
      if attributes_hash[:completed]
        football_match.update_attributes(score_attributes(attributes_hash))
      end
    end
  end

  def score_attributes(attributes_hash)
    {
      home_team_score: attributes_hash[:home_team_score],
      away_team_score: attributes_hash[:away_team_score]
    }
  end

  def all_weeks
    [1, 2]
  end
end
