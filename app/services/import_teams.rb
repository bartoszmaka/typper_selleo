require 'open-uri'
class ImportTeams < Patterns::Service
  URL = 'http://www.goal.com/en/uefa-champions-league/fixtures-results/week-1/4oogyu6o156iphvdvphwpck10'.freeze

  def call
    teams_from_website.map { |team| Team.find_or_create_by(name: team.text) }
  end

  private

  def teams_from_website
    doc = Nokogiri::HTML(open(URL))
    doc.css('span.team-name')
  end
end
