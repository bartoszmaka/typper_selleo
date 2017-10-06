require 'rails_helper'

describe FootballMatchPolicy do
  context 'when there is at least one hour before match' do
    it 'allows to modify bet' do
      match = create(:football_match, match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'))
      policy = FootballMatchPolicy.new(create(:user), match)

      travel_to(DateTime.new(2017, 9, 20, 13, 29).in_time_zone('Warsaw')) do
        expect(policy).to permit_actions(%i[edit new update create destroy])
      end
    end
  end

  context 'when there is less than one hour until match starts' do
    it 'does not allow to modify bet' do
      match = create(:football_match, match_date: DateTime.new(2017, 9, 20, 14, 30).in_time_zone('Warsaw'))
      policy = FootballMatchPolicy.new(create(:user), match)

      travel_to(DateTime.new(2017, 9, 20, 13, 31).in_time_zone('Warsaw')) do
        expect(policy).to forbid_actions(%i[edit new update create destroy])
      end
    end
  end
end
