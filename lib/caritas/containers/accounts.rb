# frozen_string_literal: true

module Containers
  module Accounts
    extend Dry::Container::Mixin

    register :repository do
      AccountRepository.new
    end

    register :create_interactor do
      Interactors::Accounts::Create.new
    end

    register :authenticate_interactor do
      Interactors::Accounts::Authenticate.new
    end

    register :signin_interactor do
      Interactors::Accounts::Signin.new
    end
  end
end
