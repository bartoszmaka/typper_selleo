class AddPointForBets < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :point, :integer, default: 0
  end
end
