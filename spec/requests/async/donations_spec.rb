require 'rails_helper'

RSpec.describe "Async::Donations", type: :request  do
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
  
  let(:path) { async_donations_path }
  
  

  before(:each) { sign_in user }
  
  context 'asking for data from a single donation box' do 
    describe 'donations timeline data' do 
      it 'should return ok status' do 
        get path, params: { chart: 'donations_timeline', ids: donation_box.id}
        expect(response.status).to eq 200
      end
    end 
    
    describe 'donation count historgram data' do 
      it 'should return ok status' do 
        get path, params: { chart: 'donation_count_histogram', ids: donation_box.id}
        expect(response.status).to eq 200
      end
    end
    
    describe 'donor count histogram data' do 
      it 'should return ok status' do 
        get path, params: { chart: 'donor_count_histogram', ids: donation_box.id }
        expect(response.status).to eq 200
      end
    end
    
    describe 'donor amount count scatter data' do 
      it 'should return ok status' do 
        get path, params: { chart: 'donor_amount_count_scatter', ids: donation_box.id }
        expect(response.status).to eq 200
      end
    end
    
  end 
end
