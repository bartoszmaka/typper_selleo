require 'rails_helper'

describe BetForm do
  context '#valid' do
    it 'requires scores to be positive' do
      user = create(:user)
      match = create(:football_match)

      form = BetForm.new(
        Bet.new,
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: -3,
        away_team_score: -1
      )

      expect { form.save }.not_to change { Bet.count }
      expect(form.errors).to have_key(:home_team_score)
      expect(form.errors).to have_key(:away_team_score)
    end

    it 'requires football_match_id' do
      user = create(:user)

      form = BetForm.new(
        Bet.new,
        user_id: user.id,
        football_match_id: nil,
        home_team_score: 4,
        away_team_score: 1
      )

      expect { form.save }.not_to change { Bet.count }
      expect(form.errors).to have_key(:football_match_id)
    end

    it 'requires user_id' do
      match = create(:football_match)

      form = BetForm.new(
        Bet.new,
        user_id: nil,
        football_match_id: match.id,
        home_team_score: 4,
        away_team_score: 1
      )

      expect { form.save }.not_to change { Bet.count }
      expect(form.errors).to have_key(:user_id)
    end

    it "user can't bet on the same match twice" do
      user = create(:user)
      match = create(:football_match)
      create(:bet, user_id: user.id, football_match_id: match.id)
      form = BetForm.new(
        Bet.new,
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: 4,
        away_team_score: 1
      )

      expect { form.save }.not_to(change { Bet.count })
    end
  end

  context '#save' do
    it 'creates bet if attributes are correct' do
      user = create(:user)
      match = create(:football_match)
      bet = Bet.new
      form = BetForm.new(
        bet,
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: 4,
        away_team_score: 1
      )

      expect { form.save }.to change { Bet.count }.by 1
      expect(bet.reload).to have_attributes(
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: 4,
        away_team_score: 1
      )
    end
  end

  context '#update' do
    it 'creates bet if attributes are correct' do
      user = create(:user)
      match = create(:football_match)
      bet = create(:bet,
                   user_id: user.id,
                   football_match_id: match.id,
                   home_team_score: 4,
                   away_team_score: 1)
      form = BetForm.new(
        bet,
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: 3,
        away_team_score: 2
      )

      expect { form.save }.not_to change { Bet.count }
      expect(bet.reload).to have_attributes(
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: 3,
        away_team_score: 2
      )
    end
  end
end
