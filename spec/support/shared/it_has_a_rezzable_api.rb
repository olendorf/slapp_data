# frozen_string_literal: true

RSpec.shared_examples 'it has a rezzable api' do |model_name|
  let(:user) { FactoryBot.create :user, expiration_date: 1.week.from_now }
  let(:klass) { "Rezzable::#{model_name.to_s.classify}".constantize }
  
  let(:web_object) do
    web_object = build(model_name, user_id: user.id)
    web_object.save
    web_object
  end

  before do
    9.times do
      web_object = build(model_name, user_id: user.id)
      web_object.save
    end
  end
  
  describe 'api validation' do 
    # post requests use the default API key
    context 'POST' do 
      let(:path) { api_rezzable_web_objects_path }
      let(:new_object) { FactoryBot.build model_name, user_id: user.id }
      let(:atts) { {url: new_object.url} }
      
      context ' with valid credentials' do
        it 'should return OK status' do 
          post path, params: atts.to_json, 
                headers: headers(new_object, api_key: Settings.default.api_key)
          expect(response).to have_http_status :created
        end
      end
      
      context 'with invalid api key' do
        before(:each) {           post path, params: atts.to_json, 
                headers: headers(new_object, api_key: SecureRandom.uuid)}
                
        it 'should return bad request status' do 
          expect(response).to have_http_status :bad_request
        end
        
        it 'should return a useful message' do 
          expect(
            response.parsed_body['message']
          ).to eq I18n.t('api.v1.errors.auth_digest')
        end
      end
      
      context 'with invalid auth time' do 
        before(:each) {           post path, params: atts.to_json, 
                headers: headers(
                            new_object, 
                            api_key: Settings.default.api_key,
                            auth_time: 60.seconds.ago
                            )
        }
        
        it 'should return bad request status' do 
          expect(response).to have_http_status :bad_request
        end
        
        it 'should return a useful message' do 
          expect(
            response.parsed_body['message']
          ).to eq I18n.t('api.v1.errors.auth_time')
        end
      end
      
    end 
    
    # all these use an object's own API key, they are all tested as a GET request
    context 'GET|PUT|DELETE' do   
      let(:web_object) do
        web_object = FactoryBot.build model_name, user_id: user.id 
        web_object.save
        web_object
      end 
      let(:path) { api_rezzable_web_object_path(web_object.object_id) }
      
      context ' with valid credentials' do
        it 'should return OK status' do 
          get path,
                headers: headers(web_object)
          expect(response).to have_http_status :ok
        end
      end
      
      context 'with invalid api key' do
        before(:each)do  
          get path,
                headers: headers(web_object, api_key: SecureRandom.uuid)
        end
        it 'should return bad request status' do 
          expect(response).to have_http_status :bad_request
        end
        
        it 'should return a useful message' do 
          expect(
            response.parsed_body['message']
          ).to eq I18n.t('api.v1.errors.auth_digest')
        end
      end
      
      context 'with invalid auth time' do 
        before(:each) { get path, headers: headers(
                              web_object, 
                              auth_time: 60.seconds.ago
                            )
        }
        
        it 'should return bad request status' do 
          expect(response).to have_http_status :bad_request
        end
        
        it 'should return a useful message' do 
          expect(
            response.parsed_body['message']
          ).to eq I18n.t('api.v1.errors.auth_time')
        end
      end
    end
  end
  
  describe 'POST' do 
    let(:path) { api_rezzable_web_objects_path }
    
    context 'web object does not exist' do 
      let(:new_object) { FactoryBot.build model_name, user_id: user.id }
      let(:atts) { {url: new_object.url} }
        
      it 'returns created status' do 
        post path, params: atts.to_json, 
              headers: headers(new_object, api_key: Settings.default.api_key)
        expect(response).to have_http_status :created
      end
      
      it 'should return a nice messge' do 
        post path, params: atts.to_json, 
              headers: headers(new_object, api_key: Settings.default.api_key)
        expect(response.parsed_body['message']
                    ).to eq I18n.t('api.v1.rezzable.create.success')
      end
      
      it 'should return the object data' do
        post path, params: atts.to_json, 
              headers: headers(new_object, api_key: Settings.default.api_key)
        expect(response.parsed_body['data'].keys).to include(
          *new_object.response_data.with_indifferent_access.keys
        )
      end
      
      it 'should create an object' do 
        expect{
        post path, params: atts.to_json, 
              headers: headers(new_object, api_key: Settings.default.api_key)
            }.to change(Rezzable::WebObject, :count).by(1)
      end
    end 
    
    context 'web object does exist' do 
      let(:atts) { {url: web_object.url} }
        
      it 'returns ok status' do 
        post path, params: atts.to_json, 
              headers: headers(web_object, api_key: Settings.default.api_key)
        expect(response).to have_http_status :ok
      end
      
      it 'should not change the number of objects' do 
        web_object
        expect{
          post path, params: atts.to_json, 
              headers: headers(web_object, api_key: Settings.default.api_key)
            }.to_not change(Rezzable::WebObject, :count)
      end
      
      it 'should change the object back to defaults' do 
        post path, params: atts.to_json, 
              headers: headers(web_object, api_key: Settings.default.api_key)
        expect(web_object.reload.setting_one).to eq('default')
      end
    end
  end
  
  describe 'GET' do
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }

    before { get path, headers: headers(web_object) }

    it 'returns OK status' do
      expect(response).to have_http_status :ok
    end

    it 'returns a nice message' do
      expect(response.parsed_body['message']).to eq 'OK'
    end

    it 'returns the data' do
      expect(response.parsed_body['data']['settings']).to include(
        'api_key' => web_object.api_key
      )
    end
  end

  describe 'GET/index' do
    let(:path) { api_rezzable_web_objects_path }

    before { get path, headers: headers(web_object) }

    it 'returns OK status' do
      expect(response).to have_http_status :ok
    end

    it 'returns a nice message' do
      expect(response.parsed_body['message']).to eq 'OK'
    end

    it 'returns all the user items' do
      expect(response.parsed_body['data'].size).to eq 10
    end
  end
  
  describe 'UPDATE' do 
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }
    
    let(:atts) { { description: 'some new idea', url: 'http://example.com' } }
    # before { put path, headers: headers(web_object) }
    
    context 'it has valid data' do 
      let(:atts) { { description: 'some new idea', url: 'http://example.com' } }
      before(:each) { put path, params: atts.to_json, headers: headers(web_object) }
      
      it 'returns OK status' do 
        put path, params: atts.to_json, headers: headers(web_object)
        expect(response).to have_http_status :ok
      end
      
      it 'returns a nice message' do 
        put path,params: atts.to_json, headers: headers(web_object)
        expect(response.parsed_body['message']
                ).to eq I18n.t('api.v1.rezzable.update.success')
      end
      
      it 'updates the object' do
        put path,params: atts.to_json, headers: headers(web_object)
        expect(web_object.reload.attributes).to include(
          "description" => atts[:description],
          "url" => atts[:url]
          )
      end
    end
  end
  
  describe 'DELETE' do 
    let(:path) { api_rezzable_web_object_path(web_object.object_key) }
    
    it 'should return ok status' do 
      delete path, headers: headers(web_object)
      expect(response).to have_http_status :ok
    end
    
    it 'should delete the object' do 
      web_object
      expect{ 
        delete path, headers: headers(web_object)
      }.to change(Rezzable::WebObject, :count).by(-1)
    end
    
    it 'should return a nice message' do 
      delete path, headers: headers(web_object)
      expect(response.parsed_body['message']
            ).to eq(I18n.t('api.v1.rezzable.destroy.success'))
    end
  end
  
end