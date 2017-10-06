require 'rails_helper'

describe BetsController do
  describe 'POST #create' do
    it 'calls CreateBet form object' do
      match = create(:football_match, match_date: 1.day.ago)
      sign_in create(:user)

      create_bet = double(BetForm)
      allow(BetForm).to receive(:new) { create_bet }
      allow(create_bet).to receive(:save) { true }


      travel_to 2.days.ago do
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

  describe 'PATCH/PUT #update' do
    it 'calls CreateBet form object' do
      match = create(:football_match, match_date: 1.day.ago)
      sign_in create(:user)

      travel_to 3.days.ago do
        @bet = create(:bet, football_match_id: match.id)
      end

      create_bet = double(BetForm)
      allow(BetForm).to receive(:new) { create_bet }
      allow(create_bet).to receive(:save) { true }


      travel_to 2.days.ago do
        post :create, params: {
          id: @bet.id,
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
end
