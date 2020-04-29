# frozen_string_literal: true

module Api
  module Params
    module Users
      class Signin < Hanami::Action::Params
        validations do
          required(:user).schema do
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end
      end
    end
  end
end
