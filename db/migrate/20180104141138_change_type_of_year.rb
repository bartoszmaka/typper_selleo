class ChangeTypeOfYear < ActiveRecord::Migration[5.1]
  def up
    change_column :rounds, :year, :string
    Round.all.each { |round| round.update(year: "#{round.year}/2018") }
  end

  def down
    change_column :rounds, :year, :integer, using: 'year::integer'
    Round.update_all(year: 2017)
  end
end
