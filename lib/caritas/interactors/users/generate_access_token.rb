# frozen_string_literal: true

module Interactors
  module Users
    class GenerateAccessToken < Interactor

      expose :access_token

      JWT_ISSUER = ENV['JWT_ISSUER']

      def initialize(dependencies = {})
        @jwt_service = dependencies.fetch(:jwt_service) do
          Containers::Services[:jwt]
        end
      end

      def call(user:)
        @access_token = @jwt_service.encode(user_id: user.id, iss: JWT_ISSUER)
      end
    end
  end
end
