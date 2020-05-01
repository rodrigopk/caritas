# frozen_string_literal: true

module Api
  module Controllers
    module Mixins
      module Authentication
        module Skip
          private

          def authenticate!; end
        end
      end
    end
  end
end
