require 'rails_helper'

describe BetsController do
  describe 'POST #create' do
    it 'calls CreateBet service object' do
      match = create(:football_match)
      sign_in create(:user)
      create_bet = double(BetForm)
      allow(BetForm).to receive(:new) { create_bet }
      allow(create_bet).to receive(:save) { true }
      post :create, params: {
        football_match_id: match.id,
        bet: {
          home_team_score: 3,
          away_team_score: 1
        }
      }
      expect(create_bet).to have_received(:save)
    end
  end
end
