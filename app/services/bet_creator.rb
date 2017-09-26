require 'csv'

class BetCreator < Patterns::Service
  FILE = Rails.root.join('public/Liga_typer.csv')

  def call
    open_file
  end

  private

  attr_reader :file
  def open_file
    CSV.read(FILE.to_s)[0].map { |email| User.create(email: email, password: email) unless User.find_by_email(email) }
    CSV.read(FILE.to_s, headers: true).map do |row|
      row_with_header = row.to_h
      home_team = Team.find_by(name: row_with_header['Mecz'].split('-')[0].strip)
      away_team = Team.find_by(name: row_with_header['Mecz'].split('-')[1].strip)
      match = FootballMatch.find_by(home_team: home_team, away_team: away_team)
      row_with_header.each_pair do |email, score|
        user = User.find_by(email: email)
        next unless !user.nil? && !score.nil?
        home_team_score = score.strip.split(/\W/)[0]
        away_team_score = score.strip.split(/\W/)[1]
        Bet.create(
          football_match: match,
          home_team_score: home_team_score,
          away_team_score: away_team_score,
          user: user
        )
      end
    end
  end
end
