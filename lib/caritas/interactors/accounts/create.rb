# frozen_string_literal: true

module Interactors
  module Accounts
    class Create < Interactor
      expose :account

      def initialize(dependencies = {})
        @account_repository = dependencies.fetch(:repository) do
          Containers::Accounts[:repository]
        end

        @password_service = dependencies.fetch(:password_service) do
          Containers::Services[:password]
        end
      end

      def call(account_attributes)
        @account = create_account(account_attributes)
      rescue Hanami::Model::UniqueConstraintViolationError
        error!(Errors.account_email_already_exists)
      rescue StandardError => e
        error!(e.message)
      end

      private

      def create_account(account_attributes)
        @account_repository.create(
          email: account_attributes[:email],
          password_digest: hashed_password(account_attributes[:password])
        )
      end

      def hashed_password(password)
        hashed_password = @password_service.encrypt(password)
      end
    end
  end
end
