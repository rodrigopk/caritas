# frozen_string_literal: true

module Middleware
  class Logger
    def initialize(app, logger, filtered_param_keys = [])
      @app = app
      @logger = logger
      @filtered_param_keys = filtered_param_keys.each(&:to_s)
    end

    def call(env)
      request_params = env['rack.input'].read

      begin
        if request_params == ''
          params = {}
        else
          params = JSON.parse(request_params)
          params = filter_params(params)
        end

        @logger.info "Parameters: #{env['REQUEST_METHOD']} \
                      #{env['PATH_INFO']} #{params}"
      rescue => e
        @logger.error e.message
        @logger.error e.backtrace.join("\n")
      end

      @app.call(env)
    end

    def filter_params(params)
      Hash[
        params.map do |key, value|
          if filtered_key?(key)
            [key, '[FILTERED]']
          else
            [key, get_value(value)]
          end
        end
      ]
    end

    def filtered_key?(key)
      @filtered_param_keys.include?(key)
    end

    def get_value(value)
      return value unless value.is_a?(Hash)

      filter_params(value)
    end
  end
end
