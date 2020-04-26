# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Users::Signup, type: :interactor do
  let(:user_attributes) do
    {
      email: 'penelope@cruz.com',
      password: 'superSecretPassword',
      first_name: 'Penelope',
      last_name: 'Cruz'
    }
  end

  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) do
      described_class.new(dependencies)
    end

    let(:user_repository) { instance_double(UserRepository) }
    let(:password_service) { class_double(Services::Password) }
    let(:dependencies) do
      {
        repository: user_repository,
        password_service: password_service
      }
    end
    let(:user) { instance_double(User) }
    let(:hashed_password) { 'encrypted_password' }

    before do
      allow(password_service).to encrypt_password
      allow(user_repository).to create_user
    end

    it 'calls' do
      interactor.call(user_attributes)
    end

    it 'encrypts the given password' do
      expect(password_service).to encrypt_password

      interactor.call(user_attributes)
    end

    it 'fetchs all institutions' do
      expect(user_repository).to create_user

      interactor.call(user_attributes)
    end

    it 'exposes the retrieved institutions' do
      context = interactor.call(user_attributes)

      expect(context.user).to equal(user)
    end
  end

  private

  def encrypt_password
    receive(:encrypt)
      .with(user_attributes[:password])
      .and_return(hashed_password)
  end

  def create_user
    receive(:create)
      .with(
        email: user_attributes[:email],
        password_digest: hashed_password,
        first_name: user_attributes[:first_name],
        last_name: user_attributes[:last_name]
      )
      .and_return(user)
  end
end
