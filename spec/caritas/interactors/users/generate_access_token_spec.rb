# frozen_string_literal: true

require 'spec_helper'

describe Interactors::Users::GenerateAccessToken do
  let(:user) { double('User', id: 'user_id') }

  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) { described_class.new(dependencies) }
    let(:dependencies) { { jwt_service: jwt_service } }
    let(:jwt_service) { double('Services::Jwt') }

    let(:access_token) { 'access_token' }
    let(:jwt_issuer) { ENV['JWT_ISSUER'] }
    let(:jwt_expiration_time) { ENV['JWT_EXPIRE_TIME'].to_i }

    it 'uses jwt issuer to encode device_id into a token' do
      expect(jwt_service).to encode_device_id_into_token

      interactor.call(user: user)
    end

    it 'exposes the generated access token' do
      allow(jwt_service).to encode_device_id_into_token
      result = interactor.call(user: user)

      expect(result.access_token).to eq(access_token)
    end
  end

  private

  def encode_device_id_into_token
    receive(:encode)
      .with(user_id: user.id, iss: jwt_issuer)
      .and_return(access_token)
  end
end
