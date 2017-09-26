class AddMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :football_matches, :round_id
    add_foreign_key :football_matches, :rounds

    add_foreign_key :bets, :users
    add_foreign_key :bets, :football_matches

    add_index :bets, :point
  end
end
