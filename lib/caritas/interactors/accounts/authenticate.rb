# frozen_string_literal: true

require_relative '../interactor'

module Interactors
  module Accounts
    class Authenticate < Interactor
      expose :account

      def initialize(dependencies = {})
        @account_repository = dependencies.fetch(:repository) do
          Containers::Accounts[:repository]
        end

        @password_service = dependencies.fetch(:password_service) do
          Containers::Services[:password]
        end
      end

      def call(email:, password:)
        account = find_account_by_email(email)
        if account
          validate_credentials(account, password)
        else
          invalid_credentials
        end
      end

      private

      def find_account_by_email(email)
        @account_repository.find_by_email(email)
      rescue StandardError => e
        error!(e.message)
      end

      def validate_credentials(account, password)
        if password_match?(account, password)
          @account = account
        else
          invalid_credentials
        end
      end

      def password_match?(account, password)
        @password_service.matches_encryptes_password?(
          password, account.password_digest
        )
      end

      def invalid_credentials
        error!(Errors.invalid_credentials)
      end
    end
  end
end
