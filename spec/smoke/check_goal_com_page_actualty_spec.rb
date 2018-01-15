require 'rails_helper'

describe 'check page actualty' do
  it 'contains all needed tags' do
    VCR.use_cassette('uefa-champions-league', re_record_interval: 1.day) do
      page = Net::HTTP.get(URI(ENV.fetch('GOAL_COM_WRAPPER_URL')))
      doc = Nokogiri::HTML.parse(page)

      expect(doc.css('div.nav-switch__label strong').text[/\d/]).not_to be nil
      expect(doc.css('div.match-main-data').first.css('time').attribute('datetime').value).not_to be nil
      expect(doc.css('div.match-main-data').first.css('div.team-home span.team-name').text).not_to be nil
      expect(doc.css('div.match-main-data').first.css('div.team-away span.team-name').text).not_to be nil
      expect(doc.css('div.match-main-data').first.css('div.team-home span.goals').text).not_to be nil
      expect(doc.css('div.match-main-data').first.css('div.team-away span.goals').text).not_to be nil
      expect(doc.css('div.match-main-data').first.css('div.match-status span').text).not_to be nil
    end
  end
end
