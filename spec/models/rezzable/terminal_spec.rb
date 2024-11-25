# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Terminal, type: :model do
  let(:user) { FactoryBot.create :owner }
  let(:terminal) do
    terminal = FactoryBot.build :terminal, user_id: user.id
    terminal.save
    terminal
  end

  it { expect(Rezzable::Terminal).to act_as(AbstractWebObject) }

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
      expect(terminal.response_data).to include(
        api_key: terminal.api_key,
        object_name: terminal.object_name,
        description: terminal.description
      )
    end
  end
end
