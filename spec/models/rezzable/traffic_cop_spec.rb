require 'rails_helper'

RSpec.describe Rezzable::TrafficCop, type: :model do
  
  let(:user) { FactoryBot.create :user }
  let(:server) do
    server = FactoryBot.build :server
    user.web_objects << server
    server
  end
  let(:traffic_cop) do
    traffic_cop = FactoryBot.build :traffic_cop, server_id: server.id
    user.web_objects << traffic_cop
    traffic_cop
  end
  
  it_behaves_like 'a rezzable object', :traffic_cop, 25
  
  
  it { expect(Rezzable::Server).to act_as(AbstractWebObject) }
  
  it { should have_many(:visits).class_name('Analyzable::Visit').dependent(:nullify) }
  
  describe 'detections' do 
    let(:detection) { FactoryBot.create :detection }
    context 'there are no visits' do  
      it 'should create a visit' do 
        expect{
          traffic_cop.update(detection: detection)
        }.to change(traffic_cop.visits, :count).by(1)
      end
      
      it 'should set the visit region' do
        traffic_cop.update(detection: detection)
        expect(traffic_cop.visits.last.region).to eq traffic_cop.region
      end
    end
  end
  
end
