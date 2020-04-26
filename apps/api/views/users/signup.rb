# frozen_string_literal: true

module Api
  module Views
    module Users
      class Signup
        include Api::View

        def render
          json_response = {
            user: {
              id: user.id,
              first_name: user.first_name,
              last_name: user.last_name,
              email: user.email,
            }
          }

          raw json_response.to_json
        end
      end
    end
  end
end
