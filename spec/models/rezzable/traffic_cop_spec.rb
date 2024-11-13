require 'rails_helper'

RSpec.describe Rezzable::TrafficCop, type: :model do
  
  it_behaves_like 'a rezzable object', :traffic_cop, 25
  
  
  it { expect(Rezzable::Server).to act_as(AbstractWebObject) }
  
  it { should have_many(:visits).class_name('Analyzable::Visit').dependent(:nullify) }
  
end
