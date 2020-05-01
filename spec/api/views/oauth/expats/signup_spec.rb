# frozen_string_literal: true

RSpec.describe Api::Views::Oauth::Expats::Signup, type: :view do
  let(:account) do
    Account.new(
      id: 'account_id',
      email: 'penelope@cruz.com',
      password_hash: 'secret'
    )
  end
  let(:expat) do
    Expat.new(
      id: 'expat_id',
      first_name: 'Penelope',
      last_name: 'Cruz'
    )
  end
  let(:access_token) { 'access_token' }

  let(:exposures) do
    { account: account, expat: expat, access_token: access_token }
  end

  let(:view) { described_class.new(nil, exposures) }

  it 'exposes #format' do
    serialized = Api::ResponseMappers::Session.call(exposures).to_json

    expect(view.render).to eq(serialized)
  end
end
