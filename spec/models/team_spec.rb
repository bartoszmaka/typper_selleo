require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'have unique name' do
    Team.create(name: 'rspec')

    expect { Team.create(name: 'RSPEC') }.to change { Team.count }.by(0)
  end

  it 'have attribute name' do
    expect(Team.new.attributes).to include('name')
  end
end
