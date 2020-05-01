# frozen_string_literal: true

module Interactors
  class Errors
    class << self
      def account_email_already_exists
        :account_email_already_exists
      end

      def invalid_credentials
        :invalid_credentials
      end
    end
  end
end
