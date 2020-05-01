# frozen_string_literal: true

module Services
  module Warden
    class JwtTokenStrategy < ::Warden::Strategies::Base
      def valid?
        !!auth_token_from_headers
      end

      # Warden checks this to see if the strategy should result in a
      # permanent login
      def store?
        false
      end

      def authenticate!
        claims = decoded_token
        user_id = claims.nil? ? nil : claims.fetch('user_id', nil)
        if claims && user_id
          success!(user_id)
        else
          fail!
        end
      end

      private

      def decoded_token
        # => fetch token: Authorization: 'Bearer <TOKEN>'
        token = auth_token_from_headers&.split(' ')&.last
        token && Jwt.decode(token)
      end

      def auth_token_from_headers
        env['HTTP_AUTHORIZATION']
      end
    end
  end
end
