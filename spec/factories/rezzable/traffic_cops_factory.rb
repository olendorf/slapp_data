# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_traffic_cop, aliases: [:traffic_cop], class: 'Rezzable::TrafficCop' do
    abstract_web_object
  end
end
