require 'rails_helper'

describe 'check page actualty' do
  it 'contains all needed tags from fixtures page' do
    VCR.use_cassette('flash-score_fixtures-champions-league') do
      page = Net::HTTP.get(URI(ENV.fetch('FLASH_SCORE_FIXTURES_WRAPPER_URL')))
      doc = Nokogiri::HTML.parse(page)

      expect(doc.css('h2.tournament').text[/\d+\/\d+/]).not_to be nil
      expect(doc.css('tr.event_round > td').text).not_to be nil
      expect(doc.css('tr.stage-scheduled > td.time').text).not_to be nil
      expect(doc.css('tr.stage-scheduled > td.team-home').text).not_to be nil
      expect(doc.css('tr.stage-scheduled > td.team-away').text).not_to be nil
    end
  end

  it 'contains all needed tags from results page' do
    VCR.use_cassette('flash-score_results-champions-league') do
      page = Net::HTTP.get(URI(ENV.fetch('FLASH_SCORE_RESULTS_WRAPPER_URL')))
      doc = Nokogiri::HTML.parse(page)

      expect(doc.css('h2.tournament').text[/\d+\/\d+/]).not_to be nil
      expect(doc.css('tr.event_round > td').text).not_to be nil
      expect(doc.css('tr.stage-finished > td.time').text).not_to be nil
      expect(doc.css('tr.stage-finished > td.team-home').text).not_to be nil
      expect(doc.css('tr.stage-finished > td.team-away').text).not_to be nil
      expect(doc.css('tr.stage-finished > td.score').text).not_to be nil
      expect(doc.css('div.top > h1').text).not_to be nil
    end
  end
end

