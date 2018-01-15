require 'rails_helper'

describe GoalComWrapper do
  describe '#each_round' do
    context "when div.nav-switch__label strong is not blank" do
      it 'yields each available rounds with all coresponding matches' do
        html_page1 = <<~HTML
          <html>
          <body>
            <div>
              <div class="nav-switch__label"><strong>GAME WEEK 1</strong></div>
              <a href='http://champion.c/week_2' class="nav-switch__next"></a>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-12T18:45:00+00:00"></time>
                <span>FT</span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">4</span>
                  <span class="team-name">Barcelona</span>
                </div>
                <div class="team-away">
                  <span class="goals">1</span>
                  <span class="team-name">Juventus</span>
                </div>
              </div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-14T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Real Madrid</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Monaco</span>
                </div>
              </div>
            </div>
           </body>
          </html>
        HTML

        html_page2 = <<~HTML
          <html>
          <body>
            <div>
              <div class="nav-switch__label"><strong>GAME WEEK 2</strong></div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-20T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Barcelona</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Real Madrid</span>
                </div>
              </div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-20T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Juventus</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Monaco</span>
                </div>
              </div>
            </div>
           </body>
          </html>
        HTML

        allow(ENV).to receive(:fetch).with('GOAL_COM_WRAPPER_URL') { 'http://champion.c/week_1' }

        stub_request(:get, 'http://champion.c/week_1').to_return(body: html_page1)
        stub_request(:get, 'http://champion.c/week_2').to_return(body: html_page2)

        expect { |round| GoalComWrapper.each_round(&round) }.to yield_control.exactly(2).times
        expect { |round| GoalComWrapper.each_round(&round) }.to yield_successive_args(
          have_attributes(
            name: 1,
            year: '2018',
            matches: match_array(
              [
                have_attributes(
                  match_date: DateTime.new(2018, 9, 12, 18, 45),
                  home_team_name: 'Barcelona',
                  away_team_name: 'Juventus',
                  home_team_score: 4,
                  away_team_score: 1,
                  completed?: true
                ),
                have_attributes(
                  match_date: DateTime.new(2018, 9, 14, 18, 45),
                  home_team_name: 'Real Madrid',
                  away_team_name: 'Monaco',
                  home_team_score: 0,
                  away_team_score: 0,
                  completed?: false
                )
              ]
            )
          ),
          have_attributes(
            name: 2,
            year: '2018',
            matches: match_array(
              [
                have_attributes(
                  match_date: DateTime.new(2018, 9, 20, 18, 45),
                  home_team_name: 'Barcelona',
                  away_team_name: 'Real Madrid',
                  home_team_score: 0,
                  away_team_score: 0,
                  completed?: false
                ),
                have_attributes(
                  match_date: DateTime.new(2018, 9, 20, 18, 45),
                  home_team_name: 'Juventus',
                  away_team_name: 'Monaco',
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

    context "when div.nav-switch__label strong is blank" do
      it 'yields each available rounds with all coresponding matches' do
        html_page1 = <<~HTML
          <html>
          <body>
            <div >
              <div class="nav-switch__label"><strong>GAME WEEK 1</strong></div>
              <a href='http://champion.c/week_2' class="nav-switch__next"></a>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-12T18:45:00+00:00"></time>
                <span>FT</span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">4</span>
                  <span class="team-name">Barcelona</span>
                </div>
                <div class="team-away">
                  <span class="goals">1</span>
                  <span class="team-name">Juventus</span>
                </div>
              </div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-14T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Real Madrid</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Monaco</span>
                </div>
              </div>
            </div>
           </body>
          </html>
        HTML

        html_page2 = <<~HTML
          <html>
          <body>
            <div >
              <div class="nav-switch__label"><strong></strong></div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-20T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Barcelona</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Real Madrid</span>
                </div>
              </div>
            </div>
             <div class="match-main-data">
              <div class="match-status">
                <time datetime="2018-09-20T18:45:00+00:00"></time>
                <span></span>
              </div>
              <div class="match-teams">
                <div class="team-home">
                  <span class="goals">0</span>
                  <span class="team-name">Juventus</span>
                </div>
                <div class="team-away">
                  <span class="goals">0</span>
                  <span class="team-name">Monaco</span>
                </div>
              </div>
            </div>
           </body>
          </html>
        HTML

        allow(ENV).to receive(:fetch).with('GOAL_COM_WRAPPER_URL') { 'http://champion.c/week_1' }

        stub_request(:get, 'http://champion.c/week_1').to_return(body: html_page1)
        stub_request(:get, 'http://champion.c/week_2').to_return(body: html_page2)

        expect { |round| GoalComWrapper.each_round(&round) }.to yield_control.exactly(1).times
        expect { |round| GoalComWrapper.each_round(&round) }.to yield_successive_args(
          have_attributes(
            name: 1,
            year: '2018',
            matches: match_array(
              [
                have_attributes(
                  match_date: DateTime.new(2018, 9, 12, 18, 45),
                  home_team_name: 'Barcelona',
                  away_team_name: 'Juventus',
                  home_team_score: 4,
                  away_team_score: 1,
                  completed?: true
                ),
                have_attributes(
                  match_date: DateTime.new(2018, 9, 14, 18, 45),
                  home_team_name: 'Real Madrid',
                  away_team_name: 'Monaco',
                  home_team_score: 0,
                  away_team_score: 0,
                  completed?: false
                )
              ]
            )
          )
        )
        expect { |round| GoalComWrapper.each_round(&round) }.not_to yield_successive_args(
          have_attributes(
            name: 2,
            year: '2018',
            matches: match_array(
              [
                have_attributes(
                  match_date: DateTime.new(2018, 9, 20, 18, 45),
                  home_team_name: 'Barcelona',
                  away_team_name: 'Real Madrid',
                  home_team_score: 0,
                  away_team_score: 0,
                  completed?: false
                ),
                have_attributes(
                  match_date: DateTime.new(2018, 9, 20, 18, 45),
                  home_team_name: 'Juventus',
                  away_team_name: 'Monaco',
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
end
