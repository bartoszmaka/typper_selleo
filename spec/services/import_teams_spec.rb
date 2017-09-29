require 'rails_helper'

describe ImportTeams do
  it 'creates 32 teams' do
    VCR.use_cassette('uefa-champions-league') do
      expect { ImportTeams.call }.to change { Team.count }.by 32
    end
  end

  it 'is idempotent service' do
    VCR.use_cassette('uefa-champions-league', allow_playback_repeats: true) do
      ImportTeams.call
      expect(Team.count).to eq(32)
      ImportTeams.call
      expect(Team.count).to eq(32)
    end
  end

  it 'imports team name properly' do
    VCR.use_cassette('uefa-champions-league') do
      ImportTeams.call
      expect(Team.all).to include(have_attributes(name: 'Roma'))
    end
  end
end
