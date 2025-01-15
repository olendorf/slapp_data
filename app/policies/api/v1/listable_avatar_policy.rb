# frozen_string_literal: true

module Api
  module V1
    # Authorization for Listable Avatars.
    class ListableAvatarPolicy < ApplicationPolicy
      def create?
        false
      end

      def index?
        true
      end
    end
  end
end
