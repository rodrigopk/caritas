# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Session do
  let(:container) { described_class }

  it 'registers the interactor to handle expat signup' do
    expect(container[:generate_access_token_interactor])
      .to be_instance_of(Interactors::Session::GenerateAccessToken)
  end
end
