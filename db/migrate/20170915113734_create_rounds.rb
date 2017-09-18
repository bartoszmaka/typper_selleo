class CreateRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :rounds do |t|
      t.integer :year, :integer
      t.integer :number, :integer
    end
  end
end
