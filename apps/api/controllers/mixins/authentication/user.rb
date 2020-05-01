# frozen_string_literal: true

module Api
  module Controllers
    module Mixins
      module Authentication
        module User
          def self.included(action)
            action.class_eval do
              before :authenticate!

              attr_writer :authenticator
            end
          end

          def current_user_id
            authenticator.user
          end

          def authenticate!
            authenticator.authenticate!
          end

          def authenticator
            @authenticator ||= request.env['warden']
          end
        end
      end
    end
  end
end
