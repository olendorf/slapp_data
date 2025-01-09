# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Async::Visits', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:traffic_cop) do 
    traffic_cop = FactoryBot.build :traffic_cop
    user.web_objects << traffic_cop
    traffic_cop
  end
  describe 'GET' do
    before(:each) do
      @avatars = FactoryBot.create_list(:avatar, 20)
      5.times do
        visitor = @avatars.sample
        visit = FactoryBot.create(:visit, avatar_name: visitor.avatar_name,
                                          avatar_key: visitor.avatar_key,
                                          traffic_cop_id: traffic_cop.id)
        detection_count = 1
        visit.detections << FactoryBot.build(:detection)
        5.times do
          previous_detection = visit.detections.last
          x = previous_detection.x + rand(-5.0..5.0)
          y = previous_detection.y + rand(-5.0..5.0)
          z = previous_detection.z + rand(-5.0..5.0)
          detection = FactoryBot.create :detection, 
                                          x: x, y: y, z: z, 
                                          created_at: visit.created_at + 
                                            (detection_count * 30)
          visit.detections << detection
          detection_count += 1
        end
      end
    end

    let(:path) { async_visits_path }

    before(:each) { sign_in user }

    context 'asking for data from a single traffic_cop' do
      describe 'visits timeline data' do 
        it 'should return ok status' do
          get path, params: { chart: 'visits_timeline', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end        
        
        # it 'should return the data' do
        #   get path, params: { chart: 'visits_timeline', ids: traffic_cop.id }
        #   expect(JSON.parse(response.body).size).to eq 1
        #   # expect(1).to eq 2
        # end
      end
      
      describe 'visits histogram data' do
        it 'should return ok status' do
          get path, params: { chart: 'visits_histogram', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the data' do
          get path, params: { chart: 'visits_histogram', ids: traffic_cop.id }
          
          expect(JSON.parse(response.body).size).to eq traffic_cop.visits.size
        end
      end
      
      describe 'visitor duraation data' do
        it 'should return ok status' do
          get path, params: { chart: 'visitors_time_histogram', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the data' do
          get path, params: { chart: 'visitors_time_histogram', ids: traffic_cop.id }
          expect(JSON.parse(response.body).size).to be_between(1, 20)
        end
      end
      
      describe 'visitor counts data' do
        it 'should return ok status' do
          get path, params: { chart: 'visitors_counts_histogram', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the data' do
          get path, params: { chart: 'visitors_counts_histogram', ids: traffic_cop.id }
          expect(JSON.parse(response.body).size).to be_between(1, 20)
        end
      end
      
      describe 'visitor duration counts scatter data' do
        it 'should return ok status' do
          get path, params: { chart: 'visitors_duration_counts_scatter', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the data' do
          get path, params: { chart: 'visitors_duration_counts_scatter', ids: traffic_cop.id }
          expect(JSON.parse(response.body).size).to be_between(1, 20)
        end
      end
      
      describe 'visit heatmap data' do
        it 'should return ok status' do
          get path, params: { chart: 'visits_heatmap', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the correct data' do
          get path, params: { chart: 'visits_heatmap', ids: traffic_cop.id }
          expect(JSON.parse(response.body).collect { |d| d[2] }.max).to eq 5
        end
      end
      
      describe 'duration heatmap data' do
        it 'should return ok status' do
          get path, params: { chart: 'duration_heatmap', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the correct data' do
          get path, params: { chart: 'duration_heatmap', ids: traffic_cop.id }
          expect(JSON.parse(response.body).collect { |d| d[2] }.max).to eq 12.5
        end
      end
      
      describe 'visit_location_heatmap' do
        it 'should return ok status' do
          get path, params: { chart: 'visit_location_heatmap', ids: traffic_cop.id }
          expect(response.status).to eq 200
        end

        it 'should return the correct data' do
          get path, params: { chart: 'visit_location_heatmap', ids: traffic_cop.id }

          expect(JSON.parse(response.body)['data'].collect { |d| d[2] }.max).to be > 0
        end
      end
      
      describe 'visitor_locations' do 
        it 'should return ok status' do 
          get path, params: {chart: 'visitor_locations', ids: traffic_cop.id}
          expect(response.status).to eq 200
        end
        
        it 'should return the correct data' do 
          get path, params: {chart: 'visitor_locations', ids: traffic_cop.id}
          expect(JSON.parse(response.body).size).to eq 5
        end
      end
    end 
  end
end
