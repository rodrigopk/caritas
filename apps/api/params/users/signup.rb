# frozen_string_literal: true

module Api
  module Params
    module Users
      class Signup < Hanami::Action::Params
        validations do
          required(:user).schema do
            required(:first_name).filled(:str?)
            optional(:last_name).filled(:str?)
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end
      end
    end
  end
end
