# frozen_string_literal: true

require 'hanami/helpers'
require 'hanami/assets'
require_relative 'controllers/mixins/authentication/user'

module Api
  class Application < Hanami::Application
    configure do
      root __dir__

      load_paths << %w[
        params
        controllers
        response_mappers
        views
      ]

      routes 'config/routes'

      middleware.use Warden::Manager do |manager|
        manager.default_strategies :jwt_authentication_token
        manager.failure_app = lambda do |_env|
          [
            401,
            {
              'Access-Control-Allow-Origin' =>
                Settings::Cors::CORS_ALLOW_ORIGIN,
              'Access-Control-Allow-Methods' =>
                Settings::Cors::CORS_ALLOW_METHODS,
              'Access-Control-Allow-Headers' =>
                Settings::Cors::CORS_ALLOW_HEADERS
            },
            ['Authentication failure']
          ]
        end
      end

      default_request_format :json
      default_response_format :json

      layout :application

      templates 'templates'

      assets do
        javascript_compressor :builtin

        stylesheet_compressor :builtin

        sources << [
          'assets'
        ]
      end

      security.x_frame_options 'DENY'

      security.x_content_type_options 'nosniff'

      security.x_xss_protection '1; mode=block'

      security.content_security_policy %(
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      )

      controller.prepare do
        include Api::Controllers::Mixins::Authentication::User
      end

      view.prepare do
        include Hanami::Helpers
        include Api::Assets::Helpers
        include Api::Views::AcceptJson
      end
    end
    configure :development do
      handle_exceptions false
    end
    configure :test do
      handle_exceptions false
    end
    configure :production do
      assets do
        compile false

        fingerprint true

        subresource_integrity :sha256
      end
    end
  end
end
