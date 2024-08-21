require 'rails_helper'

RSpec.describe Rezzable::Terminal, type: :model do
  let(:user) { FactoryBot.create :owner }
  let(:terminal) do 
    terminal = FactoryBot.build :terminal, user_id: user.id
      terminal.save
      terminal
  end
    
  it { expect(Rezzable::Terminal).to act_as(AbstractWebObject) }
    
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
