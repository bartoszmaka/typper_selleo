require 'rails_helper'

describe FootballMatch, type: :model do
  describe 'database columns' do
    it { should have_db_column :home_team_id }
    it { should have_db_column :away_team_id }
    it { should have_db_column :home_team_score }
    it { should have_db_column :away_team_score }
    it { should have_db_column :round_id }
    it { should have_db_column :match_date }
  end

  describe 'validations' do
    it { should validate_presence_of :home_team_id }
    it { should validate_presence_of :away_team_id }
    it { should validate_presence_of :match_date }
  end
end
