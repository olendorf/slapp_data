# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      class TerminalPolicy < Api::V1::OwnerPolicy      
        def give?
          show?
        end
      end
    end
  end
end
