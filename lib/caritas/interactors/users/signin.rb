# frozen_string_literal: true

module Interactors
  module Users
    class Signin < Interactor

      expose :user

      def initialize(dependencies = {})
        @authenticate_interactor = dependencies.fetch(:authenticate_interactor) do
          Containers::Users[:authenticate_interactor]
        end
      end

      def call(email:, password:)
        @user = authenticate(email: email, password: password)
      end

      private

      def authenticate(email:, password:)
        result = @authenticate_interactor.call(email: email, password: password)

        if result.success?
          result.user
        else
          error!(result.errors)
        end
      end
    end
  end
end
