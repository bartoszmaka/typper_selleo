require 'rails_helper'

describe FootballMatch::BetPolicy do
  context 'when there is at least one hour before match' do
    context 'when correct user want to modifying bet or create' do
      it 'allows to modify bet' do
        match = create(:football_match, match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'))
        user = create(:user)
        bet = create(:bet, football_match: match, user: user)
        policy_modifying = FootballMatch::BetPolicy.new(user, [match, bet])
        policy_create = FootballMatch::BetPolicy.new(user, [match])

        travel_to(DateTime.new(2017, 9, 20, 13, 29).in_time_zone('Warsaw')) do
          expect(policy_modifying).to permit_actions(%i[edit update destroy])
          expect(policy_create).to permit_actions(%i[new create])
        end
      end
    end

    context 'when another user try to modifying your bet' do
      it 'does not allow to modify bet' do
        match = create(:football_match, match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'))
        correct_user = create(:user)
        another_user = create(:user)
        bet = create(:bet, football_match: match, user: correct_user)
        policy = FootballMatch::BetPolicy.new(another_user, bet)

        expect(policy).to forbid_actions(%i[edit update destroy])
      end
    end
  end

  context 'when there is less than one hour until match starts' do
    it 'does not allow to modify bet' do
      match = create(:football_match, match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'))
      policy = FootballMatch::BetPolicy.new(create(:user), match)

      travel_to(DateTime.new(2017, 9, 20, 13, 31).in_time_zone('Warsaw')) do
        expect(policy).to forbid_actions(%i[edit new update create destroy])
      end
    end
  end
end
