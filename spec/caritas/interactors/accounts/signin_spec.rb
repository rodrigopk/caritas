# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Accounts::Signin, type: :interactor do
  let(:email) { 'penelope@cruz.com' }
  let(:password) { 'superSecretPassword' }

  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) do
      described_class.new(dependencies)
    end

    let(:authenticate_interactor) { double('AuthtenticateInteractor') }
    let(:access_token_interactor) do
      double('GenerateAccessTokenInteractor')
    end
    let(:dependencies) do
      {
        authenticate_interactor: authenticate_interactor,
        access_token_interactor: access_token_interactor,
      }
    end
    let(:account) { double('Account') }
    let(:access_token) { 'access_token' }
    let(:authenticate_result) do
      double('Interactor::Result', success?: true, account: account)
    end
    let(:generate_access_token_result) do
      double('Interactor::Result', success?: true, access_token: access_token)
    end

    subject(:result) { interactor.call(email: email, password: password) }

    before do
      allow(authenticate_interactor).to authenticate
      allow(access_token_interactor).to generate_token
    end

    it 'authenticates the account' do
      expect(authenticate_interactor).to authenticate

      interactor.call(email: email, password: password)
    end

    it 'generates access token' do
      expect(access_token_interactor).to generate_token

      interactor.call(email: email, password: password)
    end

    it 'exposes the authenticated account' do
      expect(result.account).to equal(account)
    end

    it 'exposes the access token' do
      expect(result.access_token).to equal(access_token)
    end

    describe 'given there is an error while authenticating the account' do
      let(:authenticate_result) do
        double(
          'Interactor::Result',
          success?: false,
          errors: ['interactorError']
        )
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors).to eq(['interactorError'])
      end
    end

    describe 'given there is an error while generating the access tokens' do
      let(:generate_access_token_result) do
        double(
          'Interactor::Result',
          success?: false,
          errors: ['interactorError']
        )
      end

      it 'fails' do
        expect(result.success?).to be_falsy
      end

      it 'adds the error message to the interactor errors' do
        expect(result.errors).to eq(['interactorError'])
      end
    end
  end

  private

  def authenticate
    receive(:call)
      .with(email: email, password: password)
      .and_return(authenticate_result)
  end

  def generate_token
    receive(:call)
      .with(account: account)
      .and_return(generate_access_token_result)
  end
end
