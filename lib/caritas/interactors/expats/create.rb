# frozen_string_literal: true

module Interactors
  module Expats
    class Create < Interactor

      expose :expat

      def initialize(dependencies = {})
        @expat_repository = dependencies.fetch(:repository) do
          Containers::Expats[:repository]
        end
      end

      def call(expat_attributes)
        @expat = create_expat(expat_attributes)
      rescue StandardError => e
        error!(e.message)
      end

      private

      def create_expat(expat_attributes)
        @expat_repository.create(
          account_id: expat_attributes[:account_id],
          first_name: expat_attributes[:first_name],
          last_name: expat_attributes[:last_name]
        )
      end
    end
  end
end
