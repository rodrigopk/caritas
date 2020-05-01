# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Accounts::Create, type: :interactor do
  let(:account_attributes) do
    {
      email: 'penelope@cruz.com',
      password: 'superSecretPassword'
    }
  end

  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) do
      described_class.new(dependencies)
    end

    let(:account_repository) { double('AccountRepository') }
    let(:password_service) { double('Services::Password') }
    let(:dependencies) do
      {
        repository: account_repository,
        password_service: password_service
      }
    end
    let(:account) { double('Account') }
    let(:hashed_password) { 'encrypted_password' }
    let(:result) { interactor.call(account_attributes) }

    before do
      allow(password_service).to encrypt_password
      allow(account_repository).to create_account
    end

    it 'calls' do
      interactor.call(account_attributes)
    end

    it 'encrypts the given password' do
      expect(password_service).to encrypt_password

      interactor.call(account_attributes)
    end

    it 'saves the account' do
      expect(account_repository).to create_account

      interactor.call(account_attributes)
    end

    it 'exposes the retrieved institutions' do
      expect(result.account).to equal(account)
    end

    describe 'given there is an account with the given email' do
      let(:error) { Hanami::Model::UniqueConstraintViolationError }

      before do
        allow(account_repository).to receive(:create).and_raise(error)
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors)
          .to eq([Interactors::Errors.account_email_already_exists])
      end
    end

    describe 'given there is an error while creating the account' do
      let(:db_error) { StandardError.new('db_error') }

      before do
        allow(account_repository).to receive(:create).and_raise(db_error)
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors).to eq([db_error.message])
      end
    end
  end

  private

  def encrypt_password
    receive(:encrypt)
      .with(account_attributes[:password])
      .and_return(hashed_password)
  end

  def create_account
    receive(:create)
      .with(
        email: account_attributes[:email],
        password_digest: hashed_password
      )
      .and_return(account)
  end
end
