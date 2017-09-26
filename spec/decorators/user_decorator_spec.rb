require 'rails_helper'

describe UserDecorator do
  describe '#name' do
    it 'returns user name from email' do
      user = create(:user, email: 's.example@selleo.pl')

      expect(user.decorate.name).to eql 'S. Example'
    end
  end
end
