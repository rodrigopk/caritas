# frozen_string_literal: true

module Containers
  module Expats
    extend Dry::Container::Mixin

    register :repository do
      ExpatRepository.new
    end

    register :signup_interactor do
      Interactors::Expats::Signup.new
    end

    register :create_interactor do
      Interactors::Expats::Create.new
    end
  end
end
