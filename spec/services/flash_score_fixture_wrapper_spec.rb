require 'rails_helper'

describe FlashScoreFixtureWrapper do
  describe '#each_round' do
    it 'yields each available rounds with all coresponding matches' do
      html_page = <<~HTML
        <html>
        <body>
          <h2 class="tournament"> Football » Europe » Chamions League » 2017/2018 </h2>
          <table class='soccer'>
            <tr class='event_round'>
              <td collspan='6'>1/8-finals</td>
            </tr>
            <tr class='stage-scheduled'>
              <td class='time'>13.02. 20:45</td>
              <td class='team-home'><span class="padr">Basel</span></td>
              <td class="team-away"><span class="padl">Manchester City</span></td>
            </tr>
            <tr class='event_round'>
              <td collspan='6'>2/8-finals</td>
            </tr>
            <tr class='stage-scheduled'>
              <td class='time'>14.02. 20:45</td>
              <td class='team-home'><span class="padr">dasasel</span></td>
              <td class="team-away"><span class="padl">dasnchester City</span></td>
            </tr>
          </table>
         </body>
        </html>
      HTML

      URL_PAGE = 'https://www.flashscore.com/football/europe/champions-league/fixtures/'
      allow(ENV).to receive(:fetch).with('FLASH_SCORE_FIXTURES_WRAPPER_URL') { URL_PAGE }
      stub_request(:get, URL_PAGE).to_return(body: html_page)

      binding.pry
      expect { |round| FlashScoreFixtureWrapper.each_round(&round) }.to yield_control.exactly(2).times
      expect { |round| FlashScoreFixtureWrapper.each_round(&round) }.to yield_successive_args(
        have_attributes(
          name: '1/8-finals',
          year: '2017/2018',
          matches: match_array(
            [
              have_attributes(
                match_date: DateTime.new(2018, 2, 13, 20, 45),
                home_team_name: 'Basel',
                away_team_name: 'Manchester City',
                home_team_score: 0,
                away_team_score: 0,
                completed?: false
              )
            ]
          )
        )
      )
    end
  end
end
