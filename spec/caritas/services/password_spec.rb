# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Services::Password, type: :interactor do
  let(:service) { described_class }

  describe 'encrypt' do
    let(:password_string) { 'password' }
    let(:hashed_password) { instance_double(BCrypt::Password) }

    it 'creates a new hashed password' do
      expect(BCrypt::Password).to create_bcrypt_password

      service.encrypt(password_string)
    end

    it 'returns the encrypted password' do
      allow(BCrypt::Password).to create_bcrypt_password

      expect(service.encrypt(password_string)).to eq(hashed_password)
    end
  end

  describe 'matches_encryptes_password?' do
    let(:hashed_password) { 'hashedPassword' }
    let(:password) { 'password' }

    subject(:result) do
      service.matches_encryptes_password?(password, hashed_password)
    end

    describe 'given the password matches the hash' do
      it 'returns true' do
        allow(BCrypt::Password)
          .to instantiate_bcrypt_password.and_return(password)

        expect(result).to be_truthy
      end
    end

    describe 'given the password does not matches the hash' do
      it 'returns true' do
        allow(BCrypt::Password)
          .to instantiate_bcrypt_password.and_return('somethingElse')

        expect(result).to be_falsy
      end
    end
  end

  private

  def create_bcrypt_password
    receive(:create).with(password_string).and_return(hashed_password)
  end

  def instantiate_bcrypt_password
    receive(:new).with(hashed_password)
  end
end
