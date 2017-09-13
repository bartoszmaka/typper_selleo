require 'rails_helper'

describe TeamLoader do
  it 'should create 32 teams' do
    expect(Team.all.length).to eql(0)
    TeamLoader.call
    expect(Team.all.length).to eql(32)
  end

  it "shouldn't create more team if create twice" do
    expect(Team.all.length).to eq(0)
    2.times { TeamLoader.call }
    expect(Team.all.length).to eql(32)
  end
end
