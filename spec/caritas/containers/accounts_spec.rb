# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Accounts do
  let(:container) { described_class }

  it 'registers the account repository' do
    expect(container[:repository])
      .to be_instance_of(AccountRepository)
  end

  it 'registers the interactor to handle account creation' do
    expect(container[:create_interactor])
      .to be_instance_of(Interactors::Accounts::Create)
  end

  it 'registers the interactor to handle account authentication' do
    expect(container[:authenticate_interactor])
      .to be_instance_of(Interactors::Accounts::Authenticate)
  end

  it 'registers the interactor to handle expat signin' do
    expect(container[:signin_interactor])
      .to be_instance_of(Interactors::Accounts::Signin)
  end
end
