class ImportMatches < Patterns::Service
  class ImportRound < Patterns::Service
    attr_reader :round

    def initialize(round)
      @round = round
    end

    def match_round
      Round.find_or_create_by(year: round.year, number: round.number)
    end

    def call
      UpsertMatches.call(round: match_round, matches: round.matches)
    end
  end

  class UpsertMatches < Patterns::Service
    attr_reader :round, :matches

    def initialize(round:, matches:)
      @round = round
      @matches = matches
    end

    def call
      matches.each { |match| UpsertMatch.call(match_attributes: match, round: round) }
    end
  end

  class UpsertMatch < Patterns::Service
    attr_reader :round, :match_attributes

    def initialize(round:, match_attributes:)
      @round = round
      @match_attributes = match_attributes
    end

    def call
      update_football_score
    end

    def completed?
      match_attributes.completed
    end

    def football_match
      FootballMatch.find_or_create_by(
        match_date: match_attributes.match_date,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        round_id: round.id
      )
    end

    def home_team
      Team.find_by!(name: match_attributes.home_team_name)
    end

    def away_team
      Team.find_by(name: match_attributes.away_team_name)
    end

    def update_football_score
      football_match
      if completed?
        football_match.update_attributes(
          home_team_score: match_attributes.home_team_score,
          away_team_score: match_attributes.away_team_score
        )
      end
    end
  end

  private_constant :ImportRound, :UpsertMatches, :UpsertMatch

  def call
    GoalComWrapper.each_round do |round|
      ImportRound.call(round)
    end
  end
end
