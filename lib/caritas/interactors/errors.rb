# frozen_string_literal: true

module Interactors
  class Errors
    class << self
      def user_email_already_exists
        :user_email_already_exists
      end
    end
  end
end
