# frozen_string_literal: true

class SignupParams < Hanami::Action::Params
  validations do
    required(:user).schema do
      required(:first_name).filled(:str?)
      optional(:last_name).filled(:str?)
      required(:email).filled(:str?, format?: /@/)
      required(:password).filled(:str?)
    end
  end
end

module Api
  module Controllers
    module Users
      class Signup
        include Api::Action

        expose :user

        params SignupParams

        def initialize(dependencies = {})
          @interactor = dependencies.fetch(:interactor) do
            Containers::Users[:signup_interactor]
          end
        end

        def call(params)
          if params.valid?
            handle_user_signup(params[:user])
          else
            halt 422, JSON.generate(errors: params.errors)
          end
        end

        private

        def handle_user_signup(user_attributes)
          result = @interactor.call(user_attributes)

          if result.success?
            @user = result.user
          else
            halt error_status_for_interactor_error(result.errors[0]),
                 JSON.generate(errors: { signup: result.errors })
          end
        end

        def error_status_for_interactor_error(error)
          error == Interactors::Errors.user_email_already_exists ? 409 : 400
        end
      end
    end
  end
end
