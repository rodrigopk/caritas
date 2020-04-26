# frozen_string_literal: true

require 'hanami/interactor'

module Interactors
  module Institutions
    class List
      include Hanami::Interactor

      expose :institutions

      def initialize(dependencies = {})
        @institutions_repository = dependencies.fetch(:repository) do
          Containers::Institutions[:repository]
        end
      end

      def call
        @institutions = @institutions_repository.all
      end
    end
  end
end
