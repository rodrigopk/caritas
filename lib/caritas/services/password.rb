# frozen_string_literal: true

module Services
  class Password
    def self.encrypt(password)
      BCrypt::Password.create(password)
    end
  end
end
