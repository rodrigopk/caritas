# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Users do
  let(:container) { described_class }

  it 'registers the interactor to handle user signup' do
    expect(container[:signup_interactor])
      .to be_instance_of(Interactors::Users::Signup)
  end
end
