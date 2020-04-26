# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Services do
  let(:container) { described_class }

  it 'registers the password service' do
    expect(container[:password]).to eq(Services::Password)
  end
end
