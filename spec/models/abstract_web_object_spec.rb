# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractWebObject do
  it { is_expected.to respond_to :api_key }

  it { is_expected.to validate_presence_of :object_name }
  it { is_expected.to validate_presence_of :object_key }
  it { is_expected.to validate_presence_of :region }
  it { is_expected.to validate_presence_of :position }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to be_actable }

  it { is_expected.to belong_to(:user).optional(true) }
end
