# frozen_string_literal: true

module Api
  module ResponseMappers
    class Session
      def self.call(user:, access_token:)
        {
          user: {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          },
          meta: {
            access_token: access_token,
          },
        }
      end
    end
  end
end
