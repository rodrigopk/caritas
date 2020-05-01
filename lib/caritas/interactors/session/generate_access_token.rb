# frozen_string_literal: true

module Interactors
  module Session
    class GenerateAccessToken < Interactor

      expose :access_token

      JWT_ISSUER = ENV['JWT_ISSUER']

      def initialize(dependencies = {})
        @jwt_service = dependencies.fetch(:jwt_service) do
          Containers::Services[:jwt]
        end
      end

      def call(account:)
        @access_token = @jwt_service.encode(
          account_id: account.id, iss: JWT_ISSUER
        )
      end
    end
  end
end
