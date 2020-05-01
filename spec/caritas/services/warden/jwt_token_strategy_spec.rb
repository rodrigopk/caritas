# frozen_string_literal: true

require 'spec_helper'

describe Services::Warden::JwtTokenStrategy do
  let(:strategy) { described_class.new(nil) }
  let(:user_id) { SecureRandom.uuid }
  let(:jwt) { Services::Jwt.encode(user_id: user_id) }

  before do
    allow(strategy).to receive(:env).and_return(env)
  end

  describe '#valid?' do
    context 'with valid header attributes' do
      let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{jwt}" } }

      it 'returns true' do
        expect(strategy.valid?).to be_truthy
      end
    end

    context 'with invalid header attributes' do
      let(:env) { Hash[] }

      it 'returns false' do
        expect(strategy.valid?).to be_falsy
      end
    end

    context 'with invalid header jwt' do
      let(:env) { { 'HTTP_AUTHORIZATION' => nil } }
      it 'returns false ' do
        expect(strategy.valid?).to be_falsy
      end
    end
  end

  describe '#authenticate' do
    context 'with valid jwt' do
      let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{jwt}" } }

      it 'returns :success' do
        expect(strategy.authenticate!).to eq(:success)
      end
    end

    context 'with invalid header attributes' do
      let(:env) { { 'HTTP_AUTHORIZATION' => 'Bearer invalid_jwt1232131' } }

      it 'returns :failure' do
        expect(strategy.authenticate!).to eq(:failure)
      end
    end

    context 'with missing freelancer_id in jwt payload' do
      let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{Services::Jwt.encode({})}" } }

      it 'returns :failure' do
        expect(strategy.authenticate!).to eq(:failure)
      end
    end
  end
end
