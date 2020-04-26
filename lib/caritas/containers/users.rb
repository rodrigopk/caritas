# frozen_string_literal: true

module Containers
  module Users
    extend Dry::Container::Mixin

    register :signup_interactor do
      Interactors::Users::Signup.new
    end
  end
end
