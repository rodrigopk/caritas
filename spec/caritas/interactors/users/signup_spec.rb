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

    let(:create_user_interactor) { double('CreateUserInteractor') }
    let(:access_token_interactor) do
      double('GenerateAccessTokenInteractor')
    end
    let(:dependencies) do
      {
        create_user_interactor: create_user_interactor,
        access_token_interactor: access_token_interactor,
      }
    end
    let(:user) { instance_double(User) }
    let(:access_token) { 'access_token' }
    let(:create_user_result) do
      double('Interactor::Result', success?: true, user: user)
    end
    let(:generate_access_token_result) do
      double('Interactor::Result', success?: true, access_token: access_token)
    end

    subject(:result) { interactor.call(user_attributes) }

    before do
      allow(create_user_interactor).to create_user
      allow(access_token_interactor).to generate_token
    end

    it 'calls' do
      interactor.call(user_attributes)
    end

    it 'creates an user' do
      expect(create_user_interactor).to create_user

      interactor.call(user_attributes)
    end

    it 'generates access token' do
      expect(access_token_interactor).to generate_token

      interactor.call(user_attributes)
    end

    it 'exposes the retrieved institutions' do
      expect(result.user).to equal(user)
    end

    it 'exposes the access token' do
      expect(result.access_token).to equal(access_token)
    end

    describe 'given there is an error while creating the user' do
      let(:create_user_result) do
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

  def create_user
    receive(:call)
      .with(user_attributes)
      .and_return(create_user_result)
  end

  def generate_token
    receive(:call)
      .with(user: user)
      .and_return(generate_access_token_result)
  end
end
