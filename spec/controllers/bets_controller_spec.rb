require 'rails_helper'

describe FootballMatches::BetsController do
  describe 'POST #create' do
    it 'calls BetForm with correct attributes and redirect to root path' do
      match = create(:football_match, match_date: 1.day.ago)

      sign_in create(:user)

      bet_form = double(BetForm).as_null_object
      allow(BetForm).to receive(:new) { bet_form }
      allow(bet_form).to receive(:save) { true }

      travel_to 2.days.ago do
        post :create, params: {
          football_match_id: match.id,
          bet: {
            home_team_score: 3,
            away_team_score: 1
          }
        }

        expect(bet_form).to have_received(:save)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    it 'calls CreateBet form object' do
      match = create(:football_match, match_date: 1.day.ago)
      sign_in create(:user)

      travel_to 3.days.ago do
        @bet = create(:bet, football_match_id: match.id)
      end

      bet_form = double(BetForm)
      allow(BetForm).to receive(:new) { bet_form }
      allow(bet_form).to receive(:save) { true }

      travel_to 2.days.ago do
        post :create, params: {
          id: @bet.id,
          football_match_id: match.id,
          bet: {
            home_team_score: 3,
            away_team_score: 1
          }
        }

        expect(response).to redirect_to(root_path)
        expect(BetForm).to have_received(:new).with(
          kind_of(Bet),
          hash_including(
            'home_team_score' => '3',
            'away_team_score' => '1',
            'football_match_id' => match.id.to_s
          )
        )

        expect(bet_form).to have_received(:save)
      end
    end
  end
end
