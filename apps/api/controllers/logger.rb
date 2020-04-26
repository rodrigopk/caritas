# frozen_string_literal: true

require_relative '../middleware/logger'

module Api
  module Controllers
    module Logger
      FILTERED_PARAMS = ['password', 'access_token', 'refresh_token'].freeze

      def self.included(action)
        action.class_eval do
          # Log request and response
          use Middleware::Logger, Hanami.logger, FILTERED_PARAMS
        end
      end
    end
  end
end
