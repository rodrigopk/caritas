# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Institutions do
  let(:container) { described_class }

  it 'registers the employee_token_generator service' do
    expect(container[:repository]).to be_instance_of(InstitutionRepository)
  end

  it 'registers the interactor to fetch the list of institutions' do
    expect(container[:list_interactor])
      .to be_instance_of(Interactors::Institutions::List)
  end
end
