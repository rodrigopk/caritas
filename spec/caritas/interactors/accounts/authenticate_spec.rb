# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Accounts::Authenticate, type: :interactor do
  let(:email) { 'penelope@cruz.com' }
  let(:password) { 'superSecretPassword' }

  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) do
      described_class.new(dependencies)
    end

    let(:account_repository) { double('AccountRepository') }
    let(:password_service) { class_double(Services::Password) }
    let(:dependencies) do
      {
        repository: account_repository,
        password_service: password_service
      }
    end
    let(:account) { double('User', password_digest: 'encrypted_password') }
    subject(:result) { interactor.call(email: email, password: password) }

    describe 'successful path' do
      before do
        allow(account_repository).to find_account.and_return(account)
        allow(password_service).to match_password.and_return(true)
      end

      it 'finds the account for the given email' do
        expect(account_repository).to find_account.and_return(account)

        interactor.call(email: email, password: password)
      end

      it 'compares the given password with the hashed' do
        expect(password_service).to match_password.and_return(true)

        interactor.call(email: email, password: password)
      end

      it 'exposes the retrieved account' do
        result = interactor.call(email: email, password: password)

        expect(result.account).to eq(account)
      end

      describe 'given the password does not match the hash' do
        before do
          expect(password_service).to match_password.and_return(false)
        end

        it 'fails' do
          result = interactor.call(email: email, password: password)

          expect(result.success?).to be_falsy
        end

        it 'adds the error message to the interactor errors' do
          expect(result.errors)
            .to eq([Interactors::Errors.invalid_credentials])
        end
      end
    end

    describe 'given there is no account for the given email' do
      before do
        allow(account_repository).to find_account.and_return(nil)
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors)
          .to eq([Interactors::Errors.invalid_credentials])
      end
    end

    describe 'given there is an error while finding the account' do
      let(:db_error) { StandardError.new('db_error') }

      before do
        allow(account_repository).to find_account.and_raise(db_error)
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

  def find_account
    receive(:find_by_email).with(email)
  end

  def match_password
    receive(:matches_encryptes_password?)
      .with(password, account.password_digest)
  end
end
