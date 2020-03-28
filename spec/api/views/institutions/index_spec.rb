# frozen_string_literal: true

RSpec.describe Api::Views::Institutions::Index, type: :view do
  let(:institution) do
    Institution.new(
      id: 'institution_id',
      name: 'Caritas',
      cnpj: '00000000000000',
      description: '[description]',
      website_url: 'https://website.url',
      logo_url: 'https://logo.url'
    )
  end

  let(:exposures) { { institutions: [institution] } }

  let(:view) { described_class.new(nil, exposures) }

  it 'exposes #format' do
    serialized = {
      institutions: [
        {
          id: 'institution_id',
          name: 'Caritas',
          description: '[description]',
          website_url: 'https://website.url',
          logo_url: 'https://logo.url'
        }
      ]
    }.to_json

    expect(view.render).to eq(serialized)
  end
end
