# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Interactors::Institutions::List, type: :interactor do
  it 'initializes without dependencies' do
    described_class.new
  end

  describe 'call' do
    let(:interactor) { described_class.new(dependencies) }
    let(:institutions) { [double(Institution)] }
    let(:institutions_repository) { instance_double(InstitutionRepository) }
    let(:dependencies) { { repository: institutions_repository } }

    before do
      allow(institutions_repository).to fetch_institutions
    end

    it 'calls' do
      interactor.call
    end

    it 'fetchs all institutions' do
      expect(institutions_repository).to fetch_institutions

      interactor.call
    end

    it 'exposes the retrieved institutions' do
      context = interactor.call

      expect(context.institutions).to equal(institutions)
    end
  end

  private

  def fetch_institutions
    receive(:all).and_return(institutions)
  end
end
