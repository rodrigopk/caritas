# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::Jwt, type: :service do
  let(:service) { described_class }
  let(:user_id) { 'user_id' }
  let(:jwt_issuer) { 'http://example.com' }
  let(:payload) do
    {
      user_id: user_id,
      iss: jwt_issuer
    }
  end

  let(:timestamp) { Time.parse('2018-09-03T14:31:21Z') }

  before do
    Timecop.freeze(timestamp)
  end

  describe '#encode' do
    it 'returns a new jwt' do
      jwt = service.encode(payload)
      expect(jwt).to_not be_nil
    end
  end

  describe '#decode' do
    it 'returns valid informations if the jwt is valid' do
      jwt = service.encode(payload)
      payload_decoded = service.decode(jwt)

      expect(payload_decoded).to eq(
        'user_id' => user_id,
        'iss' => jwt_issuer,
        'exp' => (timestamp + 3600).to_i
      )
    end

    it 'returns nil if jwt is not valid' do
      expect(service.decode('invalid token')).to be_nil
    end

    it 'returns nil if jwt is expired' do
      yesterday = Time.now - 86_400
      expired_jwt = service.encode(payload, yesterday)

      expect(service.decode(expired_jwt)).to be_nil
    end
  end
end
