# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Expats::Create, type: :interactor do
  let(:expat_attributes) do
    {
      account_id: 'account_id',
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

    let(:expat_repository) { double('ExpatRepository') }
    let(:dependencies) { { repository: expat_repository } }

    let(:expat) { double('Expat') }
    let(:hashed_password) { 'encrypted_password' }
    let(:result) { interactor.call(expat_attributes) }

    before do
      allow(expat_repository).to create_expat
    end

    it 'calls' do
      interactor.call(expat_attributes)
    end

    it 'saves the expat' do
      expect(expat_repository).to create_expat

      interactor.call(expat_attributes)
    end

    it 'exposes the created expat' do
      expect(result.expat).to equal(expat)
    end

    describe 'given there is an error while creating the expat' do
      let(:db_error) { StandardError.new('db_error') }

      before do
        allow(expat_repository).to receive(:create).and_raise(db_error)
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

  def create_expat
    receive(:create)
      .with(
        account_id: expat_attributes[:account_id],
        first_name: expat_attributes[:first_name],
        last_name: expat_attributes[:last_name]
      )
      .and_return(expat)
  end
end
