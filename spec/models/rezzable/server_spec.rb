require 'rails_helper'

RSpec.describe Rezzable::Server, type: :model do
  let(:user) { FactoryBot.create :owner }
  let(:server) do
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server
  end

  it { expect(Rezzable::Server).to act_as(AbstractWebObject) }

  describe '.response_data' do
    it 'should return the correct data' do
      expect(server.response_data).to include(
        api_key: server.api_key,
        object_name: server.object_name,
        description: server.description
      )
    end
  end
end
