require 'rails_helper'

RSpec.describe Rezzable::DonationBox, type: :model do
  it_behaves_like 'a rezzable object', :donation_box, 1
  
  let(:user) { FactoryBot.create :user }
  let(:donation_box) do
    donation_box = FactoryBot.build :donation_box
    user.web_objects << donation_box
    5.times do |i|
      donation_box.transactions << FactoryBot.build(
                                    :donation, 
                                    target_name: "User_#{i} Resident",
                                    target_key: SecureRandom.uuid,
                                    user_id: user.id,
                                    amount: 200)
    end
    av_key = SecureRandom.uuid
    3.times do
      donation_box.transactions << FactoryBot.build(
                                    :donation,
                                    target_name: "Big Spender",
                                    target_key: av_key,
                                    user_id: user.id,
                                    amount: 300)
    end
    donation_box
  end
  
  describe '#biggest_donor' do
    it 'should return the correct data' do 
      expect(donation_box.biggest_donor).to include(target_name: 'Big Spender', amount: 900)
    end
  end
  
  describe '#donors' do 
    it 'should return the correct data' do 
      puts donation_box.donors
      expect(donation_box.donors.size).to eq 6
    end
  end
end
