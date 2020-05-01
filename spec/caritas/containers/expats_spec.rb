# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Expats do
  let(:container) { described_class }

  it 'registers the expat repository' do
    expect(container[:repository])
      .to be_instance_of(ExpatRepository)
  end

  it 'registers the interactor to handle expat signup' do
    expect(container[:signup_interactor])
      .to be_instance_of(Interactors::Expats::Signup)
  end

  it 'registers the interactor to handle expat creation' do
    expect(container[:create_interactor])
      .to be_instance_of(Interactors::Expats::Create)
  end
end
