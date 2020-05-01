# frozen_string_literal: true

class AccountRepository < Hanami::Repository
  associations do
    has_one :expat
  end

  def find_by_email(email)
    aggregate(:expat).where(email: email).map_to(Account).one
  end
end
