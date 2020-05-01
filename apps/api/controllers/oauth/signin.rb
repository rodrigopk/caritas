# frozen_string_literal: true

module Api
  module Controllers
    module Oauth
      class Signin
        include Api::Action
        include Mixins::Authentication::Skip

        expose :account, :expat, :access_token

        params Params::Oauth::Signin

        def initialize(dependencies = {})
          @interactor = dependencies.fetch(:interactor) do
            Containers::Accounts[:signin_interactor]
          end
        end

        def call(params)
          if params.valid?
            handle_account_signin(params[:account])
          else
            halt 422, JSON.generate(errors: params.errors)
          end
        end

        private

        def handle_account_signin(account_attributes)
          result = @interactor.call(account_attributes)

          if result.success?
            @account = result.account
            @expat = result.account.expat
            @access_token = result.access_token
          else
            halt 401
          end
        end
      end
    end
  end
end
