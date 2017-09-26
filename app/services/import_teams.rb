require 'open-uri'
class ImportTeams < Patterns::Service
  def call
    teams_from_website.map { |team| Team.find_or_create_by(name: team.text) }
  end

  private

  def teams_from_website
    doc = Nokogiri::HTML(open(ENV.fetch('GOAL_COM_WRAPPER_URL')))
    doc.css('span.team-name')
  end
end
