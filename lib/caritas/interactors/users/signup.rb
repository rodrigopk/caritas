# frozen_string_literal: true

require 'hanami/interactor'

module Interactors
  module Users
    class Signup
      include Hanami::Interactor

      expose :user

      def initialize(user_attributes:, dependencies: {})
        @user_attributes = user_attributes

        inject_dependencies(dependencies)
      end

      def call
        @user = @user_repository.create(
          email: @user_attributes[:email],
          password_digest: hashed_password,
          first_name: @user_attributes[:first_name],
          last_name: @user_attributes[:last_name]
        )
      end

      private

      def inject_dependencies(dependencies)
        @user_repository = dependencies.fetch(:repository) do
          Containers::Institutions[:repository]
        end

        @password_service = dependencies.fetch(:password_service) do
          Containers::Services[:password]
        end
      end

      def hashed_password
        hashed_password = @password_service.encrypt(@user_attributes[:password])
      end
    end
  end
end
