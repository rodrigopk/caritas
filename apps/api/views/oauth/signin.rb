# frozen_string_literal: true

module Api
  module Views
    module Oauth
      class Signin
        include Api::View

        def render
          json_response = ResponseMappers::Session.call(
            account: account, expat: expat, access_token: access_token
          )

          raw json_response.to_json
        end
      end
    end
  end
end
