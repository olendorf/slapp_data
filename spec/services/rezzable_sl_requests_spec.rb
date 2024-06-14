# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RezzableSlRequest do
  let(:owner) { FactoryBot.create :owner }
  let(:web_object) do
    web_object = FactoryBot.build :web_object, user_id: owner.id
    web_object.save
    web_object
  end
  let(:uri_regex) do
    %r{\Ahttps://simhost-062cce4bc972fc71a.agni.secondlife.io:12043/cap/[-a-f0-9]{36}\?
       auth_digest=[a-f0-9]+&auth_time=[0-9]+\z}x
  end
  describe '.derez_web_object!' do
    it 'should make the request to the sl object' do
      stub = stub_request(:delete, uri_regex)
             .to_return(status: 200, body: '', headers: {})
      RezzableSlRequest.derez_web_object!(web_object)
      expect(stub).to have_been_requested
    end
  end

  describe '.update_web_object!' do
    it 'should make the request to the sl object' do
      stub = stub_request(:put, uri_regex)
             .with(body: /{"object_name":"foo","description":"bar"}/)
             .to_return(status: 200, body: '', headers: {})
      RezzableSlRequest.update_web_object!(web_object, { object_name: 'foo', description: 'bar' })
      expect(stub).to have_been_requested
    end
  end
end
