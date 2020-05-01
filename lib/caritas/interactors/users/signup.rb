# frozen_string_literal: true

module Interactors
  module Users
    class Signup < Interactor

      expose :user, :access_token

      def initialize(dependencies = {})
        @create_user_interactor = dependencies.fetch(:create_user_interactor) do
          Containers::Users[:create_interactor]
        end

        @access_token_interactor =
          dependencies.fetch(:access_token_interactor) do
            Containers::Users[:generate_access_token_interactor]
          end
      end

      def call(user_attributes)
        create_user(user_attributes)
      end

      private

      def create_user(user_attributes)
        result = @create_user_interactor.call(user_attributes)

        on_successful_interactor_result(result) do |result|
          generate_access_token(result.user)

          @user = result.user
        end
      end

      def generate_access_token(user)
        result = @access_token_interactor.call(user: user)

        on_successful_interactor_result(result) do |result|
          @access_token = result.access_token
        end
      end

      def on_successful_interactor_result(result)
        if result.success?
          yield result
        else
          error!(result.errors)
        end
      end
    end
  end
end
