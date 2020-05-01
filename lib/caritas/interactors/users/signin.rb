# frozen_string_literal: true

module Interactors
  module Users
    class Signin < Interactor

      expose :user, :access_token

      def initialize(dependencies = {})
        @authenticate_interactor = dependencies.fetch(:authenticate_interactor) do
          Containers::Users[:authenticate_interactor]
        end

        @access_token_interactor =
          dependencies.fetch(:access_token_interactor) do
            Containers::Users[:generate_access_token_interactor]
          end
      end

      def call(email:, password:)
        authenticate(email: email, password: password)
      end

      private

      def authenticate(email:, password:)
        result = @authenticate_interactor.call(email: email, password: password)

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
