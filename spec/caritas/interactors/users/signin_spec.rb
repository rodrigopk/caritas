# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Users::Signin, type: :interactor do
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
    let(:dependencies) do
      {
        authenticate_interactor: authenticate_interactor
      }
    end
    let(:user) { instance_double(User) }
    let(:authenticate_result) do
      double('Interactor::Result', success?: true, user: user)
    end

    subject(:result) { interactor.call(email: email, password: password) }

    before do
      allow(authenticate_interactor).to authenticate
    end

    it 'authenticates the user' do
      expect(authenticate_interactor).to authenticate

      interactor.call(email: email, password: password)
    end

    it 'exposes the authenticated user' do
      expect(result.user).to equal(user)
    end

    describe 'given there is an error while authenticating the user' do
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
  end

  private

  def authenticate
    receive(:call)
      .with(email: email, password: password)
      .and_return(authenticate_result)
  end
end
