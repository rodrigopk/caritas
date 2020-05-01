# frozen_string_literal: true

module Api
  module ResponseMappers
    class Session
      def self.call(account:, expat:, access_token:)
        {
          account: {
            id: account.id,
            email: account.email
          },
          expat: {
            first_name: expat.first_name,
            last_name: expat.last_name
          },
          meta: {
            access_token: access_token
          }
        }
      end
    end
  end
end
