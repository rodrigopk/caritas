# frozen_string_literal: true

require 'hanami/interactor'

module Interactors
  module Users
    class Authenticate
      include Hanami::Interactor

      expose :user

      def initialize(dependencies = {})
        @user_repository = dependencies.fetch(:repository) do
          Containers::Users[:repository]
        end

        @password_service = dependencies.fetch(:password_service) do
          Containers::Services[:password]
        end
      end

      def call(email:, password:)
        user = find_user_by_email(email)

        if user
          validate_credentials(user, password)
        else
          invalid_credentials
        end
      end

      private

      def find_user_by_email(email)
        @user_repository.find_by_email(email)
      rescue => e
        error!(e.message)
      end

      def validate_credentials(user, password)
        if password_match?(user, password)
          @user = user
        else
          invalid_credentials
        end
      end

      def password_match?(user, password)
        @password_service.matches_encryptes_password?(
          password, user.password_digest
        )
      end

      def invalid_credentials
        error!(Errors.invalid_credentials)
      end
    end
  end
end
