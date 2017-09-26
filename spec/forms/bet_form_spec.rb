require 'rails_helper'

describe BetForm do
  context 'when passed data is valid' do
    it 'creates new bet' do
      user = create(:user)
      match = create(:football_match)

      form = BetForm.new(
        Bet.new,
        {
          user_id: user.id,
          football_match_id: match.id,
          home_team_score: 4,
          away_team_score: 1
        }
      )

      expect { form.save }.to change { Bet.count }.by 1
    end
  end

  it 'requires scores to be positive' do
    user = create(:user)
    match = create(:football_match)

    form = BetForm.new(
      Bet.new,
      {
        user_id: user.id,
        football_match_id: match.id,
        home_team_score: -3,
        away_team_score: 1
      }
    )

    expect { form.save }.to change { Bet.count }.by 0
    expect(form.errors).to have_key(:home_team_score)
  end

  it 'requires football_match_id' do
    user = create(:user)

    form = BetForm.new(
      Bet.new,
      {
        user_id: user.id,
        football_match_id: nil,
        home_team_score: 4,
        away_team_score: 1
      }
    )

    expect { form.save }.to change { Bet.count }.by 0
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

    expect { form.save }.to change { Bet.count }.by 0
    expect(form.errors).to have_key(:user_id)
  end

  context 'when passed data is valid' do
    it "user can't bet on the same match twice " do
      user = create(:user)
      match = create(:football_match)

      form = BetForm.new(
        Bet.new,
        {
          user_id: user.id,
          football_match_id: match.id,
          home_team_score: 4,
          away_team_score: 1
        }
      )

      expect { form.save }.to change { Bet.count }.by 1

      form = BetForm.new(
        Bet.new,
        {
          user_id: user.id,
          football_match_id: match.id,
          home_team_score: 4,
          away_team_score: 1
        }
      )
      
      expect { form.save }.not_to change { Bet.count }
    end
  end
end
