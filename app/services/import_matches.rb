class ImportMatches < Patterns::Service
  def call
    all_weeks.each do |week|
      create_matches_for_given_week(week)
    end
  end

  def create_matches_for_given_week(week)
    match_attributes_collection = GoalComWrapper.get_round(week)
    round = Round.find_or_create_by(year: 2017, number: week)
    match_attributes_collection.each do |match_attributes_hash|
      home_team = Team.find_by!(name: match_attributes_hash[:home_team_name])
      away_team = Team.find_by!(name: match_attributes_hash[:away_team_name])
      match_attributes = {
        match_date: match_attributes_hash[:match_date],
        home_team: home_team,
        away_team: away_team,
        round_id: round.id,
      }

      FootballMatch.find_or_create_by(
        match_attributes.merge(score_attributes(match_attributes_hash))
      )
    end
  end

  def score_attributes(match_attributes_hash)
    return unless match_attributes_hash[:completed]
    {
      home_team_score: match_attributes_hash[:home_team_score],
      rway_team_score: match_attributes_hash[:away_team_score]
    }
  end

  def all_weeks
    [1, 2]
  end
end
