# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it { expect(Rezzable::WebObject).to act_as(AbstractWebObject) }
end
