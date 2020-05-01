# frozen_string_literal: true

module Interactors
  module Accounts
    class Signin < Interactor

      expose :account, :access_token

      def initialize(dependencies = {})
        @authenticate_interactor =
          dependencies.fetch(:authenticate_interactor) do
            Containers::Accounts[:authenticate_interactor]
          end

        @access_token_interactor =
          dependencies.fetch(:access_token_interactor) do
            Containers::Session[:generate_access_token_interactor]
          end
      end

      def call(email:, password:)
        authenticate(email: email, password: password)
      end

      private

      def authenticate(email:, password:)
        result = @authenticate_interactor.call(email: email, password: password)

        on_successful_interactor_result(result) do |result|
          generate_access_token(result.account)

          @account = result.account
        end
      end

      def generate_access_token(account)
        result = @access_token_interactor.call(account: account)

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
