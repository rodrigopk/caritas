# frozen_string_literal: true

module Containers
  module Users
    extend Dry::Container::Mixin

    register :repository do
      UserRepository.new
    end

    register :signup_interactor do
      Interactors::Users::Signup.new
    end

    register :create_interactor do
      Interactors::Users::Create.new
    end

    register :authenticate_interactor do
      Interactors::Users::Authenticate.new
    end
  end
end
