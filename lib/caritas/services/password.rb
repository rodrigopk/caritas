# frozen_string_literal: true

module Services
  class Password
    class << self
      def encrypt(password)
        BCrypt::Password.create(password)
      end

      def matches_encryptes_password?(password, hash)
        BCrypt::Password.new(hash) == password
      end
    end
  end
end
