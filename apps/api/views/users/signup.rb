# frozen_string_literal: true

module Api
  module Views
    module Users
      class Signup
        include Api::View

        def render
          json_response = ResponseMappers::Session.call(
            user: user, access_token: access_token
          )

          raw json_response.to_json
        end
      end
    end
  end
end
