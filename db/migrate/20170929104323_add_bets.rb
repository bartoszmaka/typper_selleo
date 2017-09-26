class AddBets < ActiveRecord::Migration[5.1]
  def change
    create_table :bets do |t|
      t.integer :football_match_id, index: true
      t.integer :user_id, index: true
      t.integer :home_team_score, null: false
      t.integer :away_team_score, null: false
    end
  end
end
