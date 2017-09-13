require 'rails_helper'

describe Round, type: :model do
  describe 'database columns' do
    it { should have_db_column :name }
    it { should have_db_column :start_date }
    it { should have_db_column :end_date }
  end
end
