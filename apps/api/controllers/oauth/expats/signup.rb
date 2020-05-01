# frozen_string_literal: true

module Api
  module Controllers
    module Oauth
      module Expats
        class Signup
          include Api::Action
          include Mixins::Authentication::Skip

          expose :account, :expat, :access_token

          params Params::Oauth::Expats::Signup

          def initialize(dependencies = {})
            @interactor = dependencies.fetch(:interactor) do
              Containers::Expats[:signup_interactor]
            end
          end

          def call(params)
            if params.valid?
              handle_expat_signup(params[:expat])
            else
              halt 422, JSON.generate(errors: params.errors)
            end
          end

          private

          def handle_expat_signup(attributes)
            result = @interactor.call(attributes)

            if result.success?
              @account = result.account
              @expat = result.expat
              @access_token = result.access_token
            else
              halt error_status_for_interactor_error(result.errors[0]),
                   JSON.generate(errors: { signup: result.errors })
            end
          end

          def error_status_for_interactor_error(error)
            error == Interactors::Errors
                     .account_email_already_exists ? 409 : 400
          end
        end
      end
    end
  end
end
