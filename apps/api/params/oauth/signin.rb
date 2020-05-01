# frozen_string_literal: true

module Api
  module Params
    module Oauth
      class Signin < Hanami::Action::Params
        validations do
          required(:account).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end
      end
    end
  end
end
