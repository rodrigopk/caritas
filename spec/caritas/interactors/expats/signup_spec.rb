# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Expats::Signup, type: :interactor do
  let(:attributes) do
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

    let(:create_account_interactor) { double('CreateAccountInteractor') }
    let(:create_expat_interactor) { double('CreateExpatInteractor') }
    let(:access_token_interactor) do
      double('GenerateAccessTokenInteractor')
    end
    let(:dependencies) do
      {
        create_account_interactor: create_account_interactor,
        create_expat_interactor: create_expat_interactor,
        access_token_interactor: access_token_interactor,
      }
    end
    let(:account) { double('Account', id: 'account_id') }
    let(:expat) { double('Expat') }
    let(:access_token) { 'access_token' }
    let(:create_account_result) do
      double('Interactor::Result', success?: true, account: account)
    end
    let(:create_expat_result) do
      double('Interactor::Result', success?: true, expat: expat)
    end
    let(:generate_access_token_result) do
      double('Interactor::Result', success?: true, access_token: access_token)
    end

    subject(:result) { interactor.call(attributes) }

    before do
      allow(create_account_interactor).to create_account
      allow(create_expat_interactor).to create_expat
      allow(access_token_interactor).to generate_token
    end

    it 'calls' do
      interactor.call(attributes)
    end

    it 'creates an account' do
      expect(create_account_interactor).to create_account

      interactor.call(attributes)
    end

    it 'creates an expat' do
      expect(create_expat_interactor).to create_expat

      interactor.call(attributes)
    end

    it 'generates access token' do
      expect(access_token_interactor).to generate_token

      interactor.call(attributes)
    end

    it 'exposes the created account' do
      expect(result.account).to equal(account)
    end

    it 'exposes the created expat' do
      expect(result.expat).to equal(expat)
    end

    it 'exposes the access token' do
      expect(result.access_token).to equal(access_token)
    end

    describe 'given there is an error while creating the account' do
      let(:create_account_result) do
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

    describe 'given there is an error while creating the expat' do
      let(:create_expat_result) do
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

  def create_account
    receive(:call)
      .with(
        email: attributes[:email],
        password: attributes[:password],
      )
      .and_return(create_account_result)
  end

  def create_expat
    receive(:call)
      .with(
        account_id: account.id,
        first_name: attributes[:first_name],
        last_name: attributes[:last_name],
      )
      .and_return(create_expat_result)
  end

  def generate_token
    receive(:call)
      .with(account: account)
      .and_return(generate_access_token_result)
  end
end
