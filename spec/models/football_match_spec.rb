require 'rails_helper'

describe FootballMatches do
  describe '#current_user_bet' do
    it 'returns user bet' do
      match = create(:football_match)
      current_user = create(:user)
      correct_bet = create(:bet, user_id: current_user.id, football_match_id: match.id)
      create(:user)
      create(:bet, football_match_id: match.id)

      expect(match.current_user_bet(current_user)).to eq correct_bet
    end
  end
end
