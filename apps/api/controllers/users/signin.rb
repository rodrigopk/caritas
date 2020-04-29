# frozen_string_literal: true

module Api
  module Controllers
    module Users
      class Signin
        include Api::Action

        expose :user

        params Params::Users::Signin

        def initialize(dependencies = {})
          @interactor = dependencies.fetch(:interactor) do
            Containers::Users[:signin_interactor]
          end
        end

        def call(params)
          if params.valid?
            handle_user_signin(params[:user])
          else
            halt 422, JSON.generate(errors: params.errors)
          end
        end

        private

        def handle_user_signin(user_attributes)
          result = @interactor.call(user_attributes)

          if result.success?
            @user = result.user
          else
            halt 401
          end
        end
      end
    end
  end
end
