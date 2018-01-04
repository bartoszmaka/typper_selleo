class ChangeNumberToNameInRound < ActiveRecord::Migration[5.1]
  def change
    rename_column :rounds, :number, :name
  end

  def up
    change_column :rounds, :name, :string
  end

  def down
    change_column :rounds, :number, :integer
  end
end
