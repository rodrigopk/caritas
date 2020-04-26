# frozen_string_literal: true

module Api
  module Controllers
    module Users
      class Signup
        include Api::Action

        expose :user

        params do
          required(:user).schema do
            required(:first_name).filled(:str?)
            optional(:last_name).filled(:str?)
            required(:email).filled(:str?, format?: /@/)
            required(:password).filled(:str?)
          end
        end

        def initialize(dependencies = {})
          @interactor = dependencies.fetch(:interactor) do
            Containers::Users[:signup_interactor]
          end
        end

        def call(params)
          if params.valid?
            result = @interactor.call(user_attributes: params[:user])

            if result.success?
              @user = result.user
            else
              halt 400, JSON.generate(errors: { signup: result.errors })
            end
          else
            halt 422, JSON.generate(errors: params.errors)
          end
        end
      end
    end
  end
end
