class ImportMatches < Patterns::Service
  def initialize
  end

  def call
    [1, 2].each do |week|
      create_matches_for_given_week(week)
    end
  end

  def create_matches_for_given_week(week)
    attribute_hashes_collection = GoalComWrapper.get_round(week)
    round = Round.find_or_create_by(year: 2017, number: week)
    attribute_hashes_collection.each do |attributes_hash|
      home_team = Team.find_by!(name: attributes_hash[:home_team_name])
      away_team = Team.find_by!(name: attributes_hash[:away_team_name])
      match_attributes = {
        match_date: attributes_hash[:match_date],
        home_team: home_team,
        away_team: away_team,
        round_id: round.id,
       }
      FootballMatch.find_or_create_by(
        match_attributes.merge!(score_attributes(attributes_hash))
      )
    end

    def score_attributes(attributes_hash)
      if attributes_hash[:completed]
        {
          home_team_score: attributes_hash[:home_team_score],
          away_team_score: attributes_hash[:away_team_score]
        }
      else
        {
          home_team_score: nil,
          away_team_score: nil
        }
      end
    end
  end
end
