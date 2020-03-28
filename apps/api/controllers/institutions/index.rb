# frozen_string_literal: true

module Api
  module Controllers
    module Institutions
      class Index
        include Api::Action

        expose :institutions

        def initialize(dependencies = {})
          @interactor = dependencies.fetch(:interactor)
        end

        def call(_params)
          result = @interactor.call

          if result.success?
            @institutions = result.institutions
          else
            halt 404
          end
        end
      end
    end
  end
end
