# frozen_string_literal: true

# Helper to mock authentication flow
require 'spec_helper'

module Spec
  module Support
    module Authentication
      module User
        def self.included(base)
          base.before do
            if defined? action
              action.authenticator = authenticator(
                user_id: 'b33dd9ed-9266-4ed5-a79c-3093f67822fa',
              )
            end
          end
        end

        private

        class Authenticator
          def initialize(params = {})
            @current_user_id = params[:user_id]
          end

          def authenticate!; end

          def user
            @current_user_id
          end
        end

        def authenticator(params = {})
          @authenticator ||= Authenticator.new(params)
        end
      end
    end
  end
end
