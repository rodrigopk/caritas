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
    let(:dependencies) do
      {
        create_user_interactor: create_user_interactor
      }
    end
    let(:user) { instance_double(User) }
    let(:create_user_result) do
      double('Interactor::Result', success?: true, user: user)
    end

    subject(:result) { interactor.call(user_attributes) }

    before do
      allow(create_user_interactor).to create_user
    end

    it 'calls' do
      interactor.call(user_attributes)
    end

    it 'creates an user' do
      expect(create_user_interactor).to create_user

      interactor.call(user_attributes)
    end

    it 'exposes the retrieved institutions' do
      expect(result.user).to equal(user)
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
  end

  private

  def create_user
    receive(:call)
      .with(user_attributes)
      .and_return(create_user_result)
  end
end
