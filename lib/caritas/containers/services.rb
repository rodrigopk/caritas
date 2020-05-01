# frozen_string_literal: true

module Containers
  module Services
    extend Dry::Container::Mixin

    register :password do
      ::Services::Password
    end

    register :jwt do
      ::Services::Jwt
    end
  end
end
