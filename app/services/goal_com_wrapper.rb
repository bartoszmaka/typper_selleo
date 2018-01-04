require 'net/http'

class GoalComWrapper
  class Round
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def name
      doc.css('div.nav-switch__label strong').text[/\d/].to_i
    end

    def is_a_round?
      doc.css('div.nav-switch__label strong').text[/\d/].present?
    end

    def year
      DateTime.parse(doc.css('div.match-main-data').first.css('time').attribute('datetime').value).year.to_s
    end

    def next_page_link
      doc.css('a.nav-switch__next').first&.attribute('href')&.value
    end

    def last?
      doc.css('a.nav-switch__next').empty?
    end

    def matches
      doc.css('div.match-main-data').map do |node|
        Match.new(node)
      end
    end

    private

    def page
      Net::HTTP.get(URI(url))
    end

    def doc
      Nokogiri::HTML.parse(page)
    end
  end

  class Match
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def match_date
      DateTime.parse(node.css('time').attribute('datetime').value)
    end

    def home_team_name
      node.css('div.team-home span.team-name').text
    end

    def away_team_name
      node.css('div.team-away span.team-name').text
    end

    def home_team_score
      node.css('div.team-home span.goals').text.to_i
    end

    def away_team_score
      node.css('div.team-away span.goals').text.to_i
    end

    def completed?
      node.css('div.match-status span').text.present?
    end
  end

  def self.each_round
    next_url = ENV.fetch('GOAL_COM_WRAPPER_URL')

    begin
      round = Round.new(url: next_url)
      if round.is_a_round?
        yield(round)
        next_url = round.next_page_link
      end
    end while !round.last? && round.is_a_round?
  end
end
