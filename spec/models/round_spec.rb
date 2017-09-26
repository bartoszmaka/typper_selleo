
# @Date:   2017-11-04 13:26:19
# @Last Modified by:   Synion
# @Last Modified time: 2017-11-06 21:42:56
require 'rails_helper'

describe Round do
  describe '#winner' do
    context 'when one user have the most points' do
      it 'returns a user with most number points' do
        user1 = create(:user, email: 's.example@selleo.pl')
        user2 = create(:user, email: 'd.wylon@selleo.pl')
        round = create(:round)
        create(:bet, user: user1, point: 3, football_match: create(:football_match, round_id: round.id))
        create(:bet, user: user2, point: 1, football_match: create(:football_match, round_id: round.id))

        expect(round.winner).to eql user1
      end
    end

    context 'when more users have that same number points' do
      it 'returns user with more exactly bets' do
        user1 = create(:user, email: 's.example@selleo.pl')
        user2 = create(:user, email: 'd.wylon@selleo.pl')
        round = create(:round)
        create(:bet, user: user1, point: 1, football_match: create(:football_match, round_id: round.id))
        create(:bet, user: user1, point: 1, football_match: create(:football_match, round_id: round.id))
        create(:bet, user: user1, point: 1, football_match: create(:football_match, round_id: round.id))
        create(:bet, user: user2, point: 3, football_match: create(:football_match, round_id: round.id))

        expect(round.winner).to eql user2
      end
    end

    context 'when more users have that same number points and the same bet with the same points' do
      it 'returns user with less difference in goals' do
        user1 = create(:user, email: 's.example@selleo.pl')
        user2 = create(:user, email: 'd.wylon@selleo.pl')
        round = create(:round)
        match_1 = create(:football_match, home_team_score: 2, away_team_score: 3, round_id: round.id)
        match_2 = create(:football_match, home_team_score: 1, away_team_score: 0, round_id: round.id)
        create(:bet, user: user1, point: 1, football_match: match_1, home_team_score: 2, away_team_score: 5)
        create(:bet, user: user1, point: 1, football_match: match_2, home_team_score: 3, away_team_score: 0)
        create(:bet, user: user2, point: 1, football_match: match_1, home_team_score: 2, away_team_score: 4)
        create(:bet, user: user2, point: 1, football_match: match_2, home_team_score: 2, away_team_score: 0)

        expect(round.winner).to eql user2
      end
    end
  end
end
