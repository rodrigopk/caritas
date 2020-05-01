# frozen_string_literal: true

module Services
  class Jwt
    DEFAULT_EXPIRE_TIME = 3600

    class << self
      def encode(payload, exp = Time.new + DEFAULT_EXPIRE_TIME)
        payload[:exp] = exp.to_i
        JWT.encode(payload, secret_jwt_key)
      end

      def decode(token)
        JWT.decode(token, secret_jwt_key).first
      rescue JWT::DecodeError, JWT::ExpiredSignature
        nil
      end

      def raise_missing_key_error(key)
        raise ArgumentError,
              "Missing secret jwt base #{key} for #{ENV['HANAMI_ENV']} \
        environment, set this value in .env file"
      end

      private

      def secret_jwt_key
        @secret_jwt_key ||= begin
          secret_jwt_key = ENV['SECRET_JWT_KEY']
          raise_missing_key_error(ENV['SECRET_JWT_KEY']) if secret_jwt_key.nil?

          secret_jwt_key
        end
      end
    end
  end
end
