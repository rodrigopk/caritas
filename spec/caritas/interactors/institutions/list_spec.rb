# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Institutions::List, type: :interactor do
  let(:interactor) { described_class }

  let(:institutions_repository) { instance_double(InstitutionRepository) }
  let(:params) do
    { dependencies: { repository: institutions_repository } }
  end

  describe 'call' do
    let(:institutions) { [double(Institution)] }

    before do
      allow(institutions_repository).to fetch_institutions
    end

    it 'calls' do
      interactor.call(params)
    end

    it 'fetchs all institutions' do
      expect(institutions_repository).to fetch_institutions

      interactor.call(params)
    end

    it 'exposes the retrieved institutions' do
      context = interactor.call(params)

      expect(context.institutions).to equal(institutions)
    end
  end

  private

  def fetch_institutions
    receive(:all).and_return(institutions)
  end
end
