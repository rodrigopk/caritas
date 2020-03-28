# frozen_string_literal: true

module Interactors
  module Institutions
    class List
      include Interactor

      before do
        inject_dependencies(context.dependencies)
      end

      def inject_dependencies(dependencies)
        @institutions_repository = dependencies.fetch(:repository) do
          Containers::Institutions[:repository]
        end
      end

      def call
        context.institutions = @institutions_repository.all
      end
    end
  end
end
