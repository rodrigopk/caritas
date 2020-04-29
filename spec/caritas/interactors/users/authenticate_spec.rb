# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Users::Authenticate, type: :interactor do
  let(:email) { 'penelope@cruz.com' }
  let(:password) { 'superSecretPassword' }

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
    let(:user) { double('User', password_digest: 'encrypted_password') }
    subject(:result) { interactor.call(email: email, password: password) }

    describe 'successful path' do
      before do
        allow(user_repository).to find_user.and_return(user)
        allow(password_service).to match_password.and_return(true)
      end

      it 'finds the user for the given email' do
        expect(user_repository).to find_user.and_return(user)

        interactor.call(email: email, password: password)
      end

      it 'compares the given password with the hashed' do
        expect(password_service).to match_password.and_return(true)

        interactor.call(email: email, password: password)
      end

      it 'exposes the retrieved user' do
        result = interactor.call(email: email, password: password)

        expect(result.user).to eq(user)
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

    describe 'given there is no user for the given email' do
      before do
        allow(user_repository).to find_user.and_return(nil)
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors)
          .to eq([Interactors::Errors.invalid_credentials])
      end
    end

    describe 'given there is an error while finding the user' do
      let(:db_error) { StandardError.new('db_error') }

      before do
        allow(user_repository).to find_user.and_raise(db_error)
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

  def find_user
    receive(:find_by_email).with(email)
  end

  def match_password
    receive(:matches_encryptes_password?)
      .with(password, user.password_digest)
  end
end
