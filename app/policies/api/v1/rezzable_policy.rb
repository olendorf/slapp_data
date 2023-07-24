# frozen_string_literal: true

module Api
  module V1
    # Base class for all rezzable authorizations. Other rezzables inherit
    # from this.
    class RezzablePolicy < ApplicationPolicy
      def show?
        true
      end

      def index?
        show?
      end

      def create?
        @user.active?
      end

      def update?
        @user.active?
      end

      def destroy?
        show?
      end

      class Scope < Scope
        # NOTE: Be explicit about which records you allow access to!
        # def resolve
        #   scope.all
        # end
      end
    end
  end
end
