# frozen_string_literal: true

require 'hanami/interactor'

module Interactors
  module Users
    class Signup
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

      def call(user_attributes)
        @user = create_user(user_attributes)
      rescue => e
        error!(e.message)
      end

      private

      def create_user(user_attributes)
        @user_repository.create(
          email: user_attributes[:email],
          password_digest: hashed_password(user_attributes[:password]),
          first_name: user_attributes[:first_name],
          last_name: user_attributes[:last_name]
        )
      end

      def hashed_password(password)
        hashed_password = @password_service.encrypt(password)
      end
    end
  end
end
