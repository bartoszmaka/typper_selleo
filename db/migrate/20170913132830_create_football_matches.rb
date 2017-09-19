class CreateFootballMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :football_matches do |t|
      t.references :away_team, foreign_key: { to_table: :teams }
      t.references :home_team, foreign_key: { to_table: :teams }
      t.integer :away_team_score
      t.integer :home_team_score
      t.datetime :match_date, null: false

      t.timestamps
    end
  end
end
