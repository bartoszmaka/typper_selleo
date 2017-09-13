require 'open-uri'
class TeamLoader < Patterns::Service
  URL = 'http://www.goal.com/en/uefa-champions-league/fixtures-results/week-1/4oogyu6o156iphvdvphwpck10'.freeze

  def call
    parse_team.each { |team| Team.find_or_create_by(name: team.text) }
  end

  private
  def parse_team
    doc = Nokogiri::HTML(open(URL))
    doc.css('span.team-name')
  end
end
