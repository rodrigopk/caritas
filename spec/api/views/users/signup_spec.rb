# frozen_string_literal: true

RSpec.describe Api::Views::Users::Signup, type: :view do
  let(:user) do
    User.new(
      id: 'user_id',
      first_name: 'Penelope',
      last_name: 'Cruz',
      email: 'penelope@cruz.com',
      password_hash: 'secret',
    )
  end

  let(:exposures) { { user: user } }

  let(:view) { described_class.new(nil, exposures) }

  it 'exposes #format' do
    serialized = {
      user: {
        id: 'user_id',
        first_name: 'Penelope',
        last_name: 'Cruz',
        email: 'penelope@cruz.com',
      },
    }.to_json

    expect(view.render).to eq(serialized)
  end
end