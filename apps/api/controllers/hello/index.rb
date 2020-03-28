# frozen_string_literal: true

module Api
  module Controllers
    module Hello
      class Index
        include Api::Action

        def call(_params)
          status 200, { message: 'Hello from Hanami!' }.to_json
        end
      end
    end
  end
end
