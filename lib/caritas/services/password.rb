# frozen_string_literal: true

module Services
  class Password
    class << self
      def encrypt(password)
        BCrypt::Password.create(password)
      end

      def matches_encryptes_password?(password, hash)
        password == BCrypt::Password.new(hash)
      end
    end
  end
end
