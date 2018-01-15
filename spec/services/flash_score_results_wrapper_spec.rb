require 'rails_helper'

describe FlashScoreResultWrapper do
  describe '#each_round' do
    it 'yields each available rounds with all coresponding matches' do
      html_page = <<~HTML
      <html>
      <body>
      <div class= 'top'>
      <h1>Champions League 2017/2018 Latest Results, Champions League 2017/2018 Current Season's Scores</h1>
            </div>
            <h2 class="tournament"> Football » Europe » Chamions League » 2017/2018 </h2>
            <table class='soccer'>
              <tr class='event_round'>
                <td collspan='6'>Round 6</td>
              </tr>
              <tr class='stage-finished'>
                <td class="time">06.12. 20:45</td>
                <td class="team-home"><span class="padr">FC Porto</span></td>
                <td class="team-away"><span class="padl">Monaco</span></td>
                <td class="score">5&nbsp;:&nbsp;2</td>
              </tr>
              <tr class='event_round'>
                <td collspan='6'>Round 5</td>
              </tr>
              <tr class='stage-finished'>
                <td class="time">22.11. 20:45</td>
                <td class="team-home"><span class="padr">Anderlecht</span></td>
                <td class="team-away"><span class="padl">Bayern Munich</span></td>
                <td class="score">1&nbsp;:&nbsp;2</td>
              </tr>
            </table>
          </body>
        </html>
      HTML

      URL_PAGE = 'https://www.flashscore.com/football/europe/champions-league/results/'
      allow(ENV).to receive(:fetch).with('FLASH_SCORE_RESULTS_WRAPPER_URL') { URL_PAGE_2 }
      stub_request(:get, URL_PAGE).to_return(body: html_page2)

      expect { |round| FlashScoreResultWrapper.each_round(&round) }.to yield_control.exactly(2).times
      expect { |round| FlashScoreResultWrapper.each_round(&round) }.to yield_successive_args(
        have_attributes(
          name: 'Round 6',
          year: '2017/2018',
          matches: match_array(
            [
              have_attributes(
                match_date: DateTime.new(2017, 12, 6, 20, 45),
                home_team_name: 'FC Porto',
                away_team_name: 'Monaco',
                home_team_score: 5,
                away_team_score: 2,
                completed?: true
              )
            ]
          )
        ),
        have_attributes(
          name: 'Round 5',
          year: '2017/2018',
          matches: match_array(
            [
              have_attributes(
                match_date: DateTime.new(2017, 11, 22, 20, 45),
                home_team_name: 'Juventus',
                away_team_name: 'Monaco',
                home_team_score: 1,
                away_team_score: 2,
                completed?: true
              )
            ]
          )
        )
      )
    end
  end
end
