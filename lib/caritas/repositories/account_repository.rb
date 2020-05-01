# frozen_string_literal: true

class AccountRepository < Hanami::Repository
  def find_by_email(email)
    accounts.where(email: email).first
  end
end
