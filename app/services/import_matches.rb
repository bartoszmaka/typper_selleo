class ImportMatches < Patterns::Service
  class ImportRound < Patterns::Service
    attr_reader :round

    def initialize(round)
      @round = round
    end

    def match_round
      Round.find_or_create_by(year: round.year, name: round.name)
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
    attr_reader :round, :match_attributes, :match, :bet

    def initialize(round:, match_attributes:)
      @round = round
      @match_attributes = match_attributes
    end

    def call
      find_or_create_match &&
        update_score
    end

    def completed?
      match_attributes.completed?
    end

    def find_or_create_match
      @match = FootballMatch.find_or_create_by(
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
      Team.find_by!(name: match_attributes.away_team_name)
    end

    def bets
      Bet.where(football_match: match)
    end

    def update_bets
      bets.each do |bet|
        @bet = bet
        set_bet_point
      end
    end

    def update_score
      if completed?
        match.update_attributes(
          home_team_score: match_attributes.home_team_score,
          away_team_score: match_attributes.away_team_score
        )
        update_bets
      end
    end

    def exact_score_matched?
      (bet.home_team_score == match.home_team_score) && (bet.away_team_score == match.away_team_score)
    end

    def result_matched?
      (bet.home_team_score <=> bet.away_team_score) == (match.home_team_score <=> match.away_team_score)
    end

    def set_bet_point
      if exact_score_matched?
        bet.update_attributes(point: 3)
      elsif result_matched?
        bet.update_attributes(point: 1)
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
