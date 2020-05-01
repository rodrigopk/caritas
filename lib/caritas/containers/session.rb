# frozen_string_literal: true

module Containers
  module Session
    extend Dry::Container::Mixin

    register :generate_access_token_interactor do
      Interactors::Session::GenerateAccessToken.new
    end
  end
end
