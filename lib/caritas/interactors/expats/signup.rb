# frozen_string_literal: true

module Interactors
  module Expats
    class Signup < Interactor
      expose :account, :expat, :access_token

      def initialize(dependencies = {})
        @create_account_interactor =
          dependencies.fetch(:create_account_interactor) do
            Containers::Accounts[:create_interactor]
          end

        @create_expat_interactor =
          dependencies.fetch(:create_expat_interactor) do
            Containers::Expats[:create_interactor]
          end

        @access_token_interactor =
          dependencies.fetch(:access_token_interactor) do
            Containers::Session[:generate_access_token_interactor]
          end
      end

      def call(attributes)
        create_account(attributes)
      end

      private

      def create_account(attributes)
        result = @create_account_interactor.call(
          email: attributes[:email],
          password: attributes[:password]
        )

        on_successful_interactor_result(result) do |result|
          create_expat(
            account: result.account,
            first_name: attributes[:first_name],
            last_name: attributes[:last_name]
          )

          @account = result.account
        end
      end

      def create_expat(account:, first_name:, last_name:)
        result = @create_expat_interactor.call(
          account_id: account.id,
          first_name: first_name,
          last_name: last_name
        )

        on_successful_interactor_result(result) do |result|
          generate_access_token(account)

          @expat = result.expat
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
