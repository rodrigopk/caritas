# frozen_string_literal: true

RSpec.describe Api::Controllers::Institutions::Index, type: :action do
  let(:action) { described_class.new(interactor: interactor) }

  let(:interactor) { class_double(Interactors::Institutions::List) }
  let(:params) { Hash[] }

  let(:institutions) { [double(Institution)] }
  let(:interactor_result) do
    double(
      Interactor::Context,
      success?: true,
      institutions: institutions
    )
  end

  it 'initializes without dependencies' do
    described_class.new
  end

  it 'fetchs the list of institutions' do
    expect(interactor).to receive(:call).and_return(interactor_result)

    action.call(params)
  end

  it 'exposes the list of institutions' do
    allow(interactor).to receive(:call).and_return(interactor_result)

    action.call(params)

    expect(action.exposures[:institutions]).to eq(institutions)
  end

  describe 'given the interactor fails' do
    let(:interactor_result) do
      double(Interactor::Context, success?: false)
    end

    it 'returns not found status' do
      allow(interactor).to receive(:call).and_return(interactor_result)

      result = action.call(params)
      expect(result[0]).to eq(404)
    end
  end
end
