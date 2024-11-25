# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Server, type: :model do
  it_behaves_like 'a rezzable object', :server, 1

  let(:user) { FactoryBot.create :owner }
  let(:server) do
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server
  end

  it {
    should have_many(:clients)
      .class_name('AbstractWebObject')
      .dependent(:nullify)
  }

  it {
    should have_many(:inventories)
      .class_name('Analyzable::Inventory')
      .dependent(:destroy)
  }

  it { expect(Rezzable::Server).to act_as(AbstractWebObject) }

  it 'should cover ransackable_associations method ' do
    expect(subject.class.ransackable_associations)
      .to include('abstract_web_object', 'actable', 'user', 'created_at')
  end

  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
      .to include('id', 'id_value')
  end

  describe '.response_data' do
    it 'should return the correct data' do
      expect(server.response_data).to include(
        server_id: server.id,
        api_key: server.api_key,
        object_name: server.object_name,
        object_key: server.object_key,
        description: server.description,
        url: server.url
      )
    end
  end
end
