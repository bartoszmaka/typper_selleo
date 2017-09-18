class AddRoundToFootballMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :football_matches, :round_id, :integer
    add_foreign_key :football_matches, :rounds
  end
end
