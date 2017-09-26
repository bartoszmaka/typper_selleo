class AddRoundToFootballMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :football_matches, :round_id, :integer
  end
end
