# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Detection, type: :model do
  it { should belong_to(:visit).class_name('Analyzable::Visit').optional(true) }
  
  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
          .to include("created_at", "id", "id_value", "updated_at", "visit_id", "x", "y", "z")
  end
end
