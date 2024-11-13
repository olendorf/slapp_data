require 'rails_helper'

RSpec.describe Analyzable::Visit, type: :model do
  it { should belong_to :user }
  it { should belong_to :traffic_cop }
  it { should have_many(:detections) }
end
