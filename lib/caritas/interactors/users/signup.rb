# frozen_string_literal: true

module Interactors
  module Users
    class Signup < Interactor

      expose :user

      def initialize(dependencies = {})
        @create_user_interactor = dependencies.fetch(:create_user_interactor) do
          Containers::Users[:create_interactor]
        end
      end

      def call(user_attributes)
        @user = create_user(user_attributes)
      end

      private

      def create_user(user_attributes)
        result = @create_user_interactor.call(user_attributes)

        if result.success?
          result.user
        else
          error!(result.errors)
        end
      end
    end
  end
end
