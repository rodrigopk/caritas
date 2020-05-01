# frozen_string_literal: true

# Registry warden strategy
Warden::Strategies.add(
  :jwt_authentication_token,
  Services::Warden::JwtTokenStrategy
)
