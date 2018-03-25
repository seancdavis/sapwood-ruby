require 'spec_helper'

RSpec.describe Sapwood::User do

  # ---------------------------------------- | New

  describe '#new' do
    it 'can instantiate a new user with a token' do
      user = Sapwood::User.new(token: 'abc123')
      expect(user.token).to eq('abc123')
    end
  end

end
