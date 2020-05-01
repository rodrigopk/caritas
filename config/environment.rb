# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require 'hanami/middleware/body_parser'

require_relative '../lib/caritas'
require_relative '../apps/api/application'

FILTERED_PARAMS = %w[password access_token].freeze

Hanami.configure do
  mount Api::Application, at: '/api'

  middleware.use Hanami::Middleware::BodyParser, :json

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/caritas_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/caritas_development'
    #    adapter :sql, 'mysql://localhost/caritas_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/caritas/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug, filter: FILTERED_PARAMS
  end

  environment :production do
    logger level: :info, formatter: :json, filter: FILTERED_PARAMS

    mailer do
      delivery :smtp,
               address: ENV.fetch('SMTP_HOST'),
               port: ENV.fetch('SMTP_PORT')
    end
  end
end
