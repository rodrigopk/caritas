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

  private

  def create_bcrypt_password
    receive(:create).with(password_string).and_return(hashed_password)
  end
end
