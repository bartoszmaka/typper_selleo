require 'net/http'

class FlashScoreFixtureWrapper
  LAST_PAGE = ENV.fetch('FLASH_SCORE_FIXTURES_WRAPPER_URL').freeze
  attr_reader :url
  def self.url
    LAST_PAGE
  end

  def self.page
    Net::HTTP.get(URI(url))
  end

  def self.doc
    Nokogiri::HTML.parse(page)
  end

  def round=(name:,year:,matches:)
    @round ||= { name: name, year: year, matches: matches }
  end

  def self.year_round
    doc.css('h2.tournament').text[/\d+\/\d+/]
  end

  def self.rounds
    doc.css('table.soccer > tr').map do |row|
      if row.css('td').count == 1
        @name = row.css('td').text
        @matches = []
      else
        time = row.css('td.time').text
        team_home = row.css('td.team-home').text
        team_away = row.css('td.team-away').text
        @match = {
          match_date: DateTime.parse(time),
          home_team_name: team_home,
          away_team_name: team_away,
          home_team_score: 0,
          away_team_score: 0,
          completed?: false
        }
        @matches.push(@match)
      end
        {year: year_round, name: @name, matches: @matches }
    end
  end

  def self.each_round
			binding.pry
    	yield(rounds)
  end
end
